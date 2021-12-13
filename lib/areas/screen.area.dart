import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_tracker/areas/model.area.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AreaScreen extends StatelessWidget {
  const AreaScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final doc = ModalRoute.of(context)?.settings.arguments as QueryDocumentSnapshot<Map<String, dynamic>>?;

    if(doc == null) return Container();

    final area = AreaModel.fromJSON(doc.data());
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(area.name),
      ),
      body: ListView(
        children: [
          _financeTimeseries(size),
          ListTile(
            leading: const Icon(Icons.poll_outlined),
            title: const Text("Name"),
            subtitle: Text(area.name),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: (){},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Description"),
            subtitle: Text(area.description),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: (){},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: const Text("Capital"),
            subtitle: Text(area.capital.toStringAsFixed(2)),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
  }

  Container _financeTimeseries(Size size) {
    return Container(
      width: size.width * 0.95,
      height: size.width * 0.8, 
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Recent Balance'
        ),
        legend: Legend(
          isVisible: true,
          isResponsive: true,
          alignment: ChartAlignment.center,
          position: LegendPosition.top
        ),
        primaryXAxis: DateTimeAxis(),
        series: [
          LineSeries(
            isVisibleInLegend: true,
            color: Colors.blue,
            name: 'Incoming',
            dataSource: <Map<String, dynamic>>[
              {
                'time': DateTime(2021, 9, 19),
                'value': 20.0
              },
              {
                'time': DateTime(2021, 10, 19),
                'value': 10.0
              },
              {
                'time': DateTime(2021, 11, 19),
                'value': 5.0
              },
            ],
            xValueMapper: (Map<String, dynamic> data, _) => data['time'], 
            yValueMapper: (Map<String, dynamic> data, _) => data['value']
          ),
          LineSeries(
            isVisibleInLegend: true,
            color: Colors.red,
            name: 'Outcoming',
            dataSource: <Map<String, dynamic>>[
              {
                'time': DateTime(2021, 9, 19),
                'value': 10.0
              },
              {
                'time': DateTime(2021, 10, 19),
                'value': 15.0
              },
              {
                'time': DateTime(2021, 11, 19),
                'value': 3.0
              },
            ],
            xValueMapper: (Map<String, dynamic> data, _) => data['time'], 
            yValueMapper: (Map<String, dynamic> data, _) => data['value']
          ),
        ]
      ),
    );
  }
}