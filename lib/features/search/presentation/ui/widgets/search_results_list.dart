import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotfoot/features/places/domain/entities/place_entity.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_state.dart';
import 'package:hotfoot/features/search/presentation/blocs/results_with_matching_address/results_with_matching_address_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_bottom_drawer/drawer_contents/drawer_contents_event.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_bloc.dart';
import 'package:hotfoot/features/search/presentation/blocs/search_map/search_map_event.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<ResultsWithMatchingAddressBloc,
          ResultsWithMatchingAddressState>(
        builder: (BuildContext context, state) {
          if (state is ResultsWithMatchingAddressEmpty ||
              state is ResultsWithMatchingAddressSelected) {
            return _buildSearchResultsList(List<PlaceEntity>());
          } else if (state is ResultsWithMatchingAddressSearching) {
            return CircularProgressIndicator();
          } else if (state is ResultsWithMatchingAddressSearched) {
            print('search success');
            if (state.resultsWithMatchingAddress.isEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Text(
                    "No search results found!\n\nPlease locate the place manually...",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
            return _buildSearchResultsList(state.resultsWithMatchingAddress);
          } else if (state is ResultsWithMatchingAddressFailure) {
            return Text(state.message);
          } else {
            print('unknown bloc state');
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildSearchResultsList(List<PlaceEntity> searchResults) {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return SearchResultsListEntry(
          searchResult: searchResults[index],
        );
      },
    );
  }
}

class SearchResultsListEntry extends StatelessWidget {
  final PlaceEntity searchResult;

  const SearchResultsListEntry({Key key, this.searchResult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(left: 15.0, right: 1.0),
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(width: 0.5, color: Colors.grey),
            )),
            child: Text(
              '${searchResult.address}',
              style: TextStyle(fontSize: 15),
            )),
      ),
      onTap: () {
        print("Selected search result with id (${searchResult.id})");
        BlocProvider.of<SearchMapBloc>(context)
            .add(SearchItemSelectedForMap(placeId: searchResult.id));
        BlocProvider.of<DrawerContentsBloc>(context)
            .add(SearchItemSelectedForDrawer(placeId: searchResult.id));
        BlocProvider.of<ResultsWithMatchingAddressBloc>(context)
            .add(ListEntryClicked(placeId: searchResult.id));
      },
    );
  }
}
