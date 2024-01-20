import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfserviceVaccination{
  Future<Uint8List>createPdf(List data,var userData,String dob)async{
    CustomCard(var listData){
      return pw.Container(
        child: pw.Column(
            children: [
              pw.Row(
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Vaccination Name: ',style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          ),),
                          pw.Text('Hospital Name: ',style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          ),),
                          pw.Text('Date: ',style:pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          ),),
                          pw.Text('Time: ',style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          )),

                        ]
                    ),
                    pw.SizedBox(
                      width: 150,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(listData['Vaccination name'].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                        pw.Text(listData['Hospital name'].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                        pw.Text(listData['Vaccination date'].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                        pw.Text(listData['Vaccination time'].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                      ],
                    ),
                  ]
              ),
              pw.Divider(
                  thickness: 2,
                  color: PdfColors.grey
              ),
            ]
        ),
      );
    }
    final ByteData bytes = await rootBundle.load('assets/playstore.png');
    final Uint8List byteList = bytes.buffer.asUint8List();
    final pw.Document doc = pw.Document();

    doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a3,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
            // alignment: pw.Alignment.center,
            // margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            // margin: pw.EdgeInsets.only(top: 4.0 * PdfPageFormat.mm ),
              child: pw.Column(
                children: [
                  pw.Container(
                      padding: const pw.EdgeInsets.only(top: 18),
                      color: PdfColors.indigo,
                      height: 200,
                      width: double.infinity,
                      child: pw.Column(
                        children: [
                          pw.Text('Family Medical History',
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 30,
                                  fontWeight: pw.FontWeight.bold
                              )),
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 10.0 * PdfPageFormat.mm,right: 10.0 * PdfPageFormat.mm,top: 10.0 * PdfPageFormat.mm),
                            child:  pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.ClipOval(
                                    child: pw.Image(
                                      pw.MemoryImage(
                                        byteList,
                                      ),
                                      width: 90.0,
                                      height: 90.0,

                                    ),
                                  ),
                                  pw.Text('Dated: ${DateFormat.yMMMMd().format(DateTime.now())}',
                                    style: pw.TextStyle(
                                        color: PdfColors.white,
                                        fontSize: 20.0,
                                        fontStyle: pw.FontStyle.italic
                                    ),
                                  ),


                                ]
                            ),
                          ),

                        ],
                      )
                  ),
                  pw.SizedBox(
                      height: 50
                  ),
                  // pw.Divider(
                  //   color: PdfColors.indigo,
                  //   thickness: 1.0,
                  // )
                ],
              ));
        },
        build: (pw.Context context) => <pw.Widget>[

          pw.Column(
            children: [
              pw.Container(
                  height: 35,
                  width: double.infinity,
                  child: pw.Center(child: pw.Text('Patient Information',style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold
                  ))),
                  color: PdfColors.indigo
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Row(
                  children: [
                    pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('Name: ',style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          ),),
                          pw.Text('Date Of Birth: ',style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          ),),
                          pw.Text('Age: ',style:pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          ),),
                          pw.Text('Blood Group: ',style: pw.TextStyle(
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold
                          )),


                        ]
                    ),
                    pw.SizedBox(
                      width: 150,
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('${userData['First name'].toString().toUpperCase()} ${userData['Last name'].toString().toUpperCase()}',style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                        pw.Text(userData[dob].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                        pw.Text(userData['Age'].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                        pw.Text(userData['Blood group'].toString().toUpperCase(),style: const pw.TextStyle(
                          fontSize: 20,
                        ),),
                      ],
                    ),
                  ]
              ),
              pw.SizedBox(
                height: 50,
              ),
              pw.Container(
                  height: 35,
                  width: double.infinity,
                  child: pw.Center(child: pw.Text('Vaccination Record',style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold
                  ))),
                  color: PdfColors.indigo
              ),
              pw.SizedBox(
                height: 20,
              ),
              for(var i in data)
                CustomCard(i),
            ],
          ),
          pw.Paragraph(text: ""),
          pw.Padding(padding: const pw.EdgeInsets.all(10)),
        ]));

    return doc.save();



  }
  Future<void>saveAndLanchFile(List<int>bytes,String fileName)async{
    final path =(await getExternalStorageDirectory())?.path;
    final file=File("$path/$fileName");
    await file.writeAsBytes(bytes,flush: true);
    OpenFile.open("$path/$fileName");

  }

}

