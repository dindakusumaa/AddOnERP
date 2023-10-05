import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notificationview_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);
  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgscreen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Notifikasi",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFAFAFA),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  CardNotification(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardNotification extends StatefulWidget {
  const CardNotification({Key? key}) : super(key: key);

  @override
  _CardNotificationState createState() => _CardNotificationState();
}

class _CardNotificationState extends State<CardNotification> {
  List<MyData> _data = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final notificationController = NotificationViewController();

      final response = await notificationController.viewData(
        id: 1,
        userid: 1,
        title: '',
        description: '',
        date: '',
      );

      final List<dynamic> nameDataList = response.data;
      print('API Response: $nameDataList');

      final List<MyData> myDataList = nameDataList.map((data) {
        int id = int.tryParse(data['id'].toString()) ?? 0;
        int userid = int.tryParse(data['userid'].toString()) ?? 0;
        String title = data['title'];
        String description = data['description'];
        String date = data['date'];

        return MyData(
          id: id,
          userid: userid,
          title: title,
          description: description,
          date: date,
        );
      }).toList();

      setState(() {
        _data = myDataList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _data.map((data) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 12, bottom: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF084D88),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    data.description,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF084D88),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      data.date.substring(0, 16) + '',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF084D88),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class MyData {
  final int id;
  final int userid;
  final String title;
  final String description;
  final String date;

  MyData({
    required this.id,
    required this.userid,
    required this.title,
    required this.description,
    required this.date,
  });
}

class MyDataTableSource extends DataTableSource {
  final List<MyData> data;
  MyDataTableSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) {
      return null;
    }
    final entry = data[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.userid.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.description,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              entry.date,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}
