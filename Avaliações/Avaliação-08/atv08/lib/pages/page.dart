import 'package:flutter/material.dart';
import '../services/service.dart';
import '../models/personagem.dart';

class PersonagensPage extends StatefulWidget {
  const PersonagensPage({Key? key}) : super(key: key);

  @override
  _PersonagensPageState createState() => _PersonagensPageState();
}

class _PersonagensPageState extends State<PersonagensPage> {
  final ApiService apiService = ApiService();
  final ScrollController _scrollController = ScrollController();

  List<Personagem> personagens = [];
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchData();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final novos = await apiService.fetchPersonagens(currentPage);
      setState(() {
        personagens.addAll(novos);
        currentPage++;
        if (novos.isEmpty) hasMore = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      personagens.clear();
      currentPage = 1;
      hasMore = true;
    });
    await _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty Characters')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: personagens.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < personagens.length) {
              final personagem = personagens[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(personagem.image),
                  ),
                  title: Text(personagem.name),
                  subtitle: Text('${personagem.species} • ${personagem.status}'),
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
