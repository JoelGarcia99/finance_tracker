import 'package:finance_tracker/assembler/assembler.dart';
import 'package:finance_tracker/auth/models/model.user.dart';
import 'package:finance_tracker/router/routes.dart';
import 'package:finance_tracker/ui/components/component.drawer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatelessWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      drawer: const LateralBar(route: RouteNames.home,),
      body: StreamBuilder(
        stream: Wrapper().homeDataStream,
        initialData: const {
          'global_profit': 150.0
        },
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          
          if(!snapshot.hasData ) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!;
          final size = MediaQuery.of(context).size;

          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _banner(context, size, data),
              _financeTimeseries(size),
              _outcomingFinance(size),
              _incomingFinance(size)
            ],
          );
        },
      ),
    );
  }

  Container _outcomingFinance(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.width, 
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: SfCircularChart(
        legend: Legend(
          isResponsive: true,
          isVisible: true,
          alignment: ChartAlignment.center,
          overflowMode: LegendItemOverflowMode.wrap,
          position: LegendPosition.top,
          toggleSeriesVisibility: true
        ),
        title: ChartTitle(
          text: 'Outcoming areas'
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap
        ),
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            name: 'Incoming',
            innerRadius: '70%',
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside
            ),
            enableTooltip: true,
            dataSource: const <Map<String, dynamic>> [
              {
                'field': 'Videogames',
                'value': 0.00
              },
              {
                'field': 'University',
                'value': 90.0
              },
              {
                'field': 'Beca',
                'value': 250.0
              },
              {
                'field': 'Personal Jobs',
                'value': 255.0
              },
            ],
            xValueMapper: (Map<String, dynamic> data, _) => data['field'], 
            yValueMapper: (Map<String, dynamic> data, _) => data['value']
          ),
        ],
      )
    );
  }
  Container _incomingFinance(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.width * 0.9, 
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.0)
      ),
      child: SfCircularChart(
        legend: Legend(
          isResponsive: true,
          isVisible: true,
          position: LegendPosition.top,
          toggleSeriesVisibility: true
        ),
        title: ChartTitle(
          text: 'Outcoming areas'
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap
        ),
        series: <CircularSeries>[
          DoughnutSeries<Map<String, dynamic>, String>(
            name: 'Outcomings',
            innerRadius: '70%',
            dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                // Positioning the data label
                labelPosition: ChartDataLabelPosition.outside
            ),
            enableTooltip: true,
            dataSource: const <Map<String, dynamic>> [
              {
                'field': 'Videogames',
                'value': 9.99
              },
              {
                'field': 'Food',
                'value': 1.99
              },
              {
                'field': 'Transport',
                'value': 4.50
              },
            ],
            xValueMapper: (Map<String, dynamic> data, _) => data['field'], 
            yValueMapper: (Map<String, dynamic> data, _) => data['value']
          ),
        ],
      )
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
          text: 'Monthly Balance'
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

  Widget _banner(BuildContext context, Size size, Map<String, dynamic> data) {
    return StreamBuilder<UserModel?>(
      stream: Wrapper().currentUserStream,
      builder: (context, snapshot) {

        if(!snapshot.hasData && Wrapper().currentUser == null) {
          return const Center(
            child: CircularProgressIndicator()
          );
        }

        final user = (snapshot.data ?? Wrapper().currentUser)!;

        return Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: size.width * 0.1,
                child: const Icon(Icons.person),
              ),
              Column(
                children: [
                  Text(
                    "${user.name} ${user.lastName}",
                    style: Theme.of(context).textTheme.headline4
                  ),
                  const Text("Global profit:"),
                  Text(
                    '\$ ${(data['global_profit'] as double).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline2
                  )
                ],
              )
            ],
          ),
        );
      }
    );
  }
}