import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kino/domain/api_client/image_downloader.dart';
import 'package:kino/domain/factories/screen_factory.dart';
import 'package:kino/ui/widgets/search_list/search_list_cubit.dart';


class _SearchInput<T extends BaseListCubit<dynamic, dynamic>>
    extends StatelessWidget {
  const _SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<T>();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: cubit.search,
        decoration: InputDecoration(
          labelText: 'Поиск',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}


class GeneralListWidget<T extends BaseListCubit<dynamic, dynamic>>
    extends StatefulWidget {
  final String title;
  final String routeName;
  final DetailsType detailsType;

  const GeneralListWidget({
    Key? key,
    required this.title,
    required this.routeName,
    required this.detailsType, 
  }) : super(key: key);

  @override
  _GeneralListWidgetState<T> createState() => _GeneralListWidgetState<T>();
}

class _GeneralListWidgetState<T extends BaseListCubit<dynamic, dynamic>>
    extends State<GeneralListWidget<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    context.read<T>().setupLocale(locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [
          _ContentList<T>(
            routeName: widget.routeName, 
            detailsType: widget.detailsType,
          ),
          _SearchInput<T>(),
        ],
      ),
    );
  }
}



class _ContentList<T extends BaseListCubit<dynamic, dynamic>>
    extends StatelessWidget {
  final String routeName;
  final DetailsType detailsType; 
  
  const _ContentList({
    Key? key, 
    required this.routeName, 
    required this.detailsType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<T>();
    final items = cubit.state.items;

    return ListView.builder(
      padding: const EdgeInsets.only(top: 70),
      itemCount: items.length,
      itemExtent: 163,
      itemBuilder: (context, index) {
        cubit.showedItemAtIndex(index);
        final item = items[index];

        return _ListRowWidget(
          item: item,
          onTap: () {
            final args = MovieDetailsArguments(
              id: item.id, 
              type: detailsType,
            );
            Navigator.of(context).pushNamed(routeName, arguments: args);
          },
        );
      },
    );
  }
}


class _ListRowWidget extends StatelessWidget {
  final ListRowData item;
  final VoidCallback onTap;

  const _ListRowWidget({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (item.posterPath != null)
                  Image.network(
                    ImageDownloader.imageUrl(item.posterPath!),
                    width: 95,
                  ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Text(
                        item.releaseDate,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        item.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(onTap: onTap),
          ),
        ],
      ),
    );
  }
}
