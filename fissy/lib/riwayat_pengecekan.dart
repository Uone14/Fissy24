import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class riwayat_pengecekan extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Riwayat Pengecekan'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('history').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading data'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var documents = snapshot.data!.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var item = documents[index];
                var date =
                    item['date']; // assuming 'date' is a field in your document
                var description =
                    item['description']; // assuming 'description' is a field

                return HistoryItem(date: date, description: description);
              },
            );
          },
        ),
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String date;
  final String description;

  const HistoryItem({Key? key, required this.date, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }
}
