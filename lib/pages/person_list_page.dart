import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/bloc/person_list_bloc.dart';
import 'package:flutter_exam/models/person_model.dart';
import 'package:flutter_exam/widgets/persons_table.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widgets/person_list_item.dart';

class PersonListPage extends StatefulWidget {
  const PersonListPage({super.key});

  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  Widget? content;
  List<Person> allPersons = [];
  bool _isLast = false;
  final RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _fetchPersons() {
    context.read<PersonBloc>().add(const FetchPersons());
  }

  void _refreshPersons() {
    allPersons = [];
    _isLast = false;
    context.read<PersonBloc>().add(const RefreshPersons());
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 600.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Person List')),
      body: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          if (state is PersonLoading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (state is PersonError) {
            allPersons = [];
            _isLast = false;
            _refreshController.resetNoData();
            _refreshController.refreshFailed();
            content = Center(child: Text(state.message));
          } else if (state is PersonLoaded) {
            _isLast = state.hasReachedMax;
            allPersons = state.persons;
            _refreshController.loadComplete();
            _refreshController.refreshCompleted();

            if (_isLast && allPersons.isEmpty) {
              content = const Center(
                child: Text(
                  'No person available',
                ),
              );
            } else if (screenWidth > mobileBreakpoint) {
              content = SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: PersonsTable(allPersons: allPersons),
              );
            } else {
              content = ListView.builder(
                itemCount: allPersons.length,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return PersonListItem(
                    person: allPersons[i],
                    index: i,
                  );
                },
              );
            }
          }
          if (_isLast) {
            _refreshController.loadNoData();
          }
          if (screenWidth > mobileBreakpoint) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * .30, vertical: 12),
              child: Column(
                children: [
                  Expanded(child: content!),
                  if (_isLast) const Text('No more data'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number or rows: ${allPersons.length}'),
                      Row(
                        children: [
                          _buildButton(
                            label: 'Load More',
                            onPressed: _isLast ? null : _fetchPersons,
                          ),
                          const SizedBox(width: 12),
                          _buildButton(
                            label: 'Refresh',
                            onPressed: _refreshPersons,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            // Mobile will use SmartRefresher
            return SmartRefresher(
              enablePullUp: allPersons.isNotEmpty,
              enablePullDown: true,
              controller: _refreshController,
              onRefresh: _refreshPersons,
              onLoading: _fetchPersons,
              child: content!,
            );
          }
        },
      ),
    );
  }

  ElevatedButton _buildButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
