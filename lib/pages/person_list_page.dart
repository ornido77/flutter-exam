import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/bloc/person_list_bloc.dart';
import 'package:flutter_exam/models/person_model.dart';
import 'package:flutter_exam/widgets/persons_table.dart';
import 'package:flutter_exam/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../widgets/person_list_item.dart';

class PersonListPage extends StatefulWidget {
  const PersonListPage({super.key});

  @override
  State<PersonListPage> createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  Widget? content;
  List<Person> _allPersons = [];
  bool _isLast = false;
  int _currentPage = 1;
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
    _allPersons = [];
    _isLast = false;
    context.read<PersonBloc>().add(const RefreshPersons());
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double mobileBreakpoint = 600.0;

    return Scaffold(
      appBar: AppBar(
        title: reusableText(
          'Person List',
          size: 24,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<PersonBloc, PersonState>(
        builder: (context, state) {
          if (state is PersonLoading) {
            content = const Center(child: CircularProgressIndicator());
          } else if (state is PersonError) {
            _allPersons = [];
            _isLast = false;
            _currentPage = 1;
            _refreshController.resetNoData();
            _refreshController.refreshFailed();
            content = Center(child: Text(state.message));
          } else if (state is PersonLoaded) {
            _isLast = state.hasReachedMax;
            _allPersons = state.persons;
            _currentPage = state.currentPage;
            _refreshController.loadComplete();
            _refreshController.refreshCompleted();

            if (_isLast && _allPersons.isEmpty) {
              content = Center(
                child: reusableText('No person available',
                    size: 18, color: Colors.black54),
              );
            } else if (screenWidth > mobileBreakpoint) {
              content = SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: PersonsTable(allPersons: _allPersons),
              );
            } else {
              content = ListView.builder(
                itemCount: _allPersons.length,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  return PersonListItem(
                    person: _allPersons[i],
                  );
                },
              );
            }
          }
          if (_isLast) {
            _refreshController.loadNoData();
          }

          if (screenWidth > mobileBreakpoint) {
            // Web layout
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.25, vertical: 16),
              child: Column(
                children: [
                  Expanded(child: content!),
                  const SizedBox(height: 16),
                  if (_isLast)
                    reusableText(
                      'No more data',
                      size: 16,
                      color: Colors.grey,
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      reusableText(
                        'Page: $_currentPage/3',
                        size: 16,
                        color: Colors.black87,
                      ),
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
            // Mobile layout using SmartRefresher
            return SmartRefresher(
              enablePullUp: _allPersons.isNotEmpty,
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: reusableText(label, color: Colors.white),
    );
  }
}
