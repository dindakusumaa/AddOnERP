import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'scanauditbarang_view.dart';
import 'home_view.dart';
import 'audithasil_view.dart';
import '../utils/globals.dart';
import '../controllers/auditstock_controller.dart';
import '../controllers/audituser_controller.dart';
import '../controllers/response_model.dart';

class AuditLokasiView extends StatefulWidget {
  String result;
  List<String> resultBarang;

  AuditLokasiView({required this.result, required this.resultBarang, Key? key})
      : super(key: key);

  @override
  State<AuditLokasiView> createState() => _AuditLokasiViewState();
}

class _AuditLokasiViewState extends State<AuditLokasiView> {
  String barcodeAuditLokasiResult = globalBarcodeLokasiResult;
  late DateTime currentTime;
  final AuditUserController _auditUserController = Get.put(AuditUserController());
  final idController = TextEditingController();
  final pbarangController = TextEditingController();
  final plokasiController = TextEditingController();
  String idInventory = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentTime();
    _auditUserController.fetchIdInventory().then((id) {
      setState(() {
        idInventory = id.toString();
        idController.text = idInventory.toString();
      });
    });
    String pbarangList = widget.resultBarang.join('\n');
    plokasiController.text = barcodeAuditLokasiResult;
    pbarangController.text = pbarangList;
  }

  Future<void> _fetchCurrentTime() async {
    try {
      setState(() {
        currentTime = DateTime.now();
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _submitStock() async {
    final int id = int.parse(idController.text);
    final String plokasi = plokasiController.text;
    List<String> errorMessages = [];

    try {
      await _fetchCurrentTime();

      for (String pbarang in widget.resultBarang) {
        ResponseModel response = await AuditStockController.postFormData(
          id: id,
          pbarang: pbarang,
          plokasi: plokasi,
          pdate: currentTime,
        );

        if (response.status == 0) {
          errorMessages.add('Request gagal: ${response.message}');
        } else if (response.status != 1) {
          errorMessages.add('Terjadi kesalahan: Response tidak valid.');
        }
      }

      if (errorMessages.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessages.join('\n')),
          ),
        );
      } else {
        Get.snackbar('Stock Berhasil Diupload', 'Congratulations');
      }

      widget.resultBarang.clear(); 
      setState(() {
        widget.resultBarang = []; 
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              width: 360,
              height: 800,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A77AC), Color(0xFF5AB4E1)],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 70),
                    Container(
                    margin: const EdgeInsets.symmetric(horizontal: 26),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              Text(
                                'LOKASI: ',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                barcodeAuditLokasiResult,
                                style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Visibility(
                    visible: widget.resultBarang.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Container(
                        width: 1 * MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Daftar Barang',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.resultBarang.join('\n'),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.blue[900],
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.resultBarang.isEmpty,
                    child: EmptyData(),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScanAuditBarangView()),
                            );
                          },
                          icon: const Icon(Icons.qr_code_scanner, size: 15),
                          label: const Text('Scan Barang',
                              style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(8, 77, 136, 136),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            minimumSize: const Size(130, 48),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () {
                            _submitStock();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const AuditHasilView()),
                            );
                          },
                          icon: const Icon(Icons.cloud_upload, size: 15),
                          label: const Text('UPLOAD', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(8, 77, 136, 136),
                            onPrimary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            minimumSize: const Size(100, 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: const Color(0xFF2A77AC),
                elevation: 0.0,
                leading: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeView()),
                    );
                  },
                  child: Image.asset(
                    'assets/icon.back.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                title: const Text(
                  "Audit Stock",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 26),
      child: Container(
        width: 1 * MediaQuery.of(context).size.width,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.nodata.png',
              width: 30,
              height: 30,
              color: Colors.blue[900],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                'Tidak ada hasil scan barang',
                style: GoogleFonts.poppins(
                  color: Colors.blue[900],
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
