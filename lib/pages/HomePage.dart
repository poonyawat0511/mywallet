import 'package:flutter/material.dart';
import 'package:mywallet/common_widgets/tran_builder.dart';
import 'package:mywallet/form_page/tran_form_page.dart';
import 'package:mywallet/models/account.dart';
import 'package:mywallet/models/category.dart';
import 'package:mywallet/models/transfer.dart';
import 'package:mywallet/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  Future<List<Transfer>> _getTransfers() async {
    return await _databaseService.tranfer10Newest();
  }

  Future<List<Account>> _getAccounts() async {
    return await _databaseService.accountAll();
  }

  Future<List<Category>> _getCategories() async {
    return await _databaseService.categoryAll();
  }

  Future<void> _onTransferDelete(Transfer tran) async {
    await _databaseService.deleteTran(tran.id!);
    setState(() {});
  }

  Future<void> _exportToCSV() async {
    await _databaseService.exportDataToCSV();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data exported to CSV file.'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Page'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _exportToCSV,
              icon: Icon(Icons.file_download),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Trans'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TranBuilder(
              future: _getTransfers(),
              onEdit: (value) {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (_) => TranFormPage(tran: value),
                        fullscreenDialog: true,
                      ),
                    )
                    .then((_) => setState(() {}));
              },
              onDelete: _onTransferDelete,
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TranFormPage(),
                    fullscreenDialog: true,
                  ),
                );
                setState(() {});
              },
              heroTag: 'addTrans',
              child: Icon(Icons.currency_exchange),
            ),
          ],
        ),
      ),
    );
  }
}
