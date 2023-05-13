import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notiboy/Model/statistic/StatisticStatusModel.dart';
import 'package:notiboy/controller/common_provider.dart';
import 'package:notiboy/service/internet_service.dart';
import 'package:notiboy/utils/color.dart';
import 'package:notiboy/utils/const.dart';
import 'package:notiboy/utils/string.dart';
import 'package:notiboy/utils/widget.dart';
import 'package:notiboy/widget/dropDown2.dart';
import 'package:notiboy/widget/drop_down.dart';
import 'package:notiboy/widget/loader.dart';
import 'package:notiboy/widget/toast.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StatisticScreen extends StatefulWidget {
  final Function? functionCall;

  const StatisticScreen({Key? key, this.functionCall}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  final List<String> items = [
    'Spouse',
    'Partner',
    'Friend',
    'Other',
  ];
  int touchedIndex = -1;
  StatisticStatusModel? statisticStatusModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark
          ? kIsWeb
              ? Clr.black
              : Clr.dark
          : kIsWeb
              ? Clr.white
              : Clr.blueBg,
      body: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          return _mainBody(sizingInformation.deviceScreenType);
        },
      ),
    );
  }

  Widget _mainBody(DeviceScreenType deviceScreenType) {
    switch (deviceScreenType) {
      case DeviceScreenType.desktop:
        return _buildDesktopBody();
      case DeviceScreenType.mobile:
      default:
        return _buildMobileBody();
    }
  }

  _buildMobileBody() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  selectImage(
                    image: "assets/algorand.png",
                    color: isDark ? Clr.mode : Clr.white,
                  ),
                  Spacer(),
                  changeMode(
                    () {
                      widget.functionCall?.call();
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  setting(context),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    cmnDropDown(title: Str.statistic),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 3,
                          child: DropDown2(
                            items: items,
                            hintTitle: "Select Channel",
                            color: isDark ? Clr.black : Clr.blue,
                            iconColor: isDark ? Clr.blue : Clr.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18,
                    ),

                    ///Pie Chart
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          startDegreeOffset: 210,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 1,
                          centerSpaceRadius: 0,
                          sections: showingSections(),
                        ),
                      ),
                    ),

                    ///Line Chart
                    // AspectRatio(
                    //   aspectRatio: 1.23,
                    //   child: Stack(
                    //     children: <Widget>[
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.stretch,
                    //         children: <Widget>[
                    //           Expanded(
                    //             child: Padding(
                    //               padding: EdgeInsets.only(right: 16, left: 6),
                    //               child: _LineChart(),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: 10,
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange,
                          radius: 5,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Number of users",
                          style: TextStyle(
                            color: isDark ? Clr.white : Clr.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 5,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Number of announcements",
                          style: TextStyle(
                            color: isDark ? Clr.white : Clr.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildDesktopBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? Clr.bottomBg : Clr.blueBgWeb,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  selectImage(
                    image: "assets/algorand.png",
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Str.statistic,
                    style: TextStyle(
                      color: isDark ? Clr.white : Clr.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  changeMode(
                    () {
                      widget.functionCall?.call();
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  setting(context),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 150,
                    child: DropDownWidgetScreen(title: "XL32...YJD"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.orange,
                                radius: 5,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Text(
                                  "Number of users",
                                  style: TextStyle(
                                    color: isDark ? Clr.white : Clr.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.tealAccent,
                                radius: 5,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Text(
                                  "Number of notifications",
                                  style: TextStyle(
                                    color: isDark ? Clr.white : Clr.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                radius: 5,
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Text(
                                  "Number of announcements",
                                  style: TextStyle(
                                    color: isDark ? Clr.white : Clr.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      selectChannel(title: "Select Channel")
                    ],
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: 210,
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 1,
                        centerSpaceRadius: 0,
                        sections: showingSections(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  statisticStatus() async {
    final hasInternet = await checkInternets();
    try {
      Loader.sw();
      final url = baseUrl + "";

      dynamic response = await AllProvider().apiProvider(
        url: url,
        method: Method.get,
      );
      statisticStatusModel = await StatisticStatusModel.fromJson(response);

      if (statisticStatusModel != null) {
        MyToast().succesToast(toast: statisticStatusModel?.message.toString());
        //Navigate screen here
      } else {
        if (hasInternet == true) {
          MyToast().errorToast(toast: Validate.somethingWrong);
        }
      }
      Loader.hd();
      setState(() {});
    } catch (error) {
      Loader.hd();
      print("error == ${error.toString()}");
      if (hasInternet == true) {
        MyToast().errorToast(toast: Validate.somethingWrong);
      }
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      3,
      (i) {
        final isTouched = i == touchedIndex;
        const color0 = Colors.orange;
        const color1 = Colors.lightGreen;
        const color2 = Colors.cyan;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 33,
              title: '',
              radius: 150,
              titlePositionPercentageOffset: 0.55,
              borderSide: BorderSide(color: Clr.black, width: 2),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 33,
              title: '',
              radius: 150,
              borderSide: BorderSide(color: Clr.black, width: 2),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 10,
              title: '',
              radius: 150,
              borderSide: BorderSide(color: Clr.black, width: 2),
              titlePositionPercentageOffset: 0.6,
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(sampleData2);
  }

  LineChartData get sampleData2 => LineChartData(
        lineTouchData: lineTouchData2,
        gridData: gridData,
        titlesData: titlesData2,
        borderData: borderData,
        lineBarsData: lineBarsData2,
        minX: 0,
        maxX: 14,
        maxY: 6,
        minY: 0,
      );

  LineTouchData get lineTouchData2 => LineTouchData(
        enabled: false,
      );

  FlTitlesData get titlesData2 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData2 => [
        lineChartBarData2_1,
        lineChartBarData2_3,
      ];

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData2_1,
        lineChartBarData2_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Clr.white,
      fontSize: 12,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 2:
        text = '10';
        break;
      case 3:
        text = '20';
        break;
      case 4:
        text = '30';
        break;
      case 5:
        text = '40';
        break;
      case 6:
        text = '50';
        break;
      case 7:
        text = '60';
        break;
      case 8:
        text = '70';
        break;
      case 9:
        text = '80';
        break;
      case 10:
        text = '90';
        break;
      case 11:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Clr.white,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = Text('0', style: style);
        break;
      case 2:
        text = Text('10', style: style);
        break;
      case 3:
        text = Text('20', style: style);
        break;
      case 4:
        text = Text('30', style: style);
        break;
      case 5:
        text = Text('40', style: style);
        break;
      case 6:
        text = Text('50', style: style);
        break;
      case 7:
        text = Text('60', style: style);
        break;
      case 8:
        text = Text('70', style: style);
        break;
      case 9:
        text = Text('80', style: style);
        break;
      case 10:
        text = Text('90', style: style);
        break;
      case 11:
        text = Text('100', style: style);
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: Colors.white, width: 1),
          left: const BorderSide(color: Colors.white),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.orange,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(2, 4),
          FlSpot(3, 1.8),
          FlSpot(4, 5),
          FlSpot(5, 2),
          FlSpot(6, 2.2),
          FlSpot(7, 1.8),
          FlSpot(8, 1.8),
          FlSpot(9, 1.8),
          FlSpot(10, 1.8),
          FlSpot(11, 1),
        ],
      );

  LineChartBarData get lineChartBarData2_3 => LineChartBarData(
        isCurved: true,
        curveSmoothness: 0,
        color: Colors.blue,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: true),
        belowBarData: BarAreaData(show: false),
        spots: [
          FlSpot(1, 3.8),
          FlSpot(3, 1.9),
          FlSpot(5, 5),
          FlSpot(6, 3.3),
          FlSpot(8, 4.5),
          FlSpot(9, 4.5),
          FlSpot(11, 4.5),
        ],
      );
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
