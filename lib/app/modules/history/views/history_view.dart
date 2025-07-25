import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/history_controller.dart';
import '../controllers/accounting_controller.dart';
import '../controllers/pose_history_controller.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.put(HistoryController());
    final accountingController = Get.put(AccountingController());
    final poseController = Get.put(PoseHistoryController());

    historyController.fetchHistory();
    accountingController.fetchAccountingLogs();
    poseController.fetchPoseHistory();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Pengguna'),
          centerTitle: true,
          backgroundColor: Colors.pinkAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Notes SADARI'),
              Tab(text: 'Log Aktivitas'),
              Tab(text: 'Deteksi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Notes SADARI
            Obx(() {
              return RefreshIndicator(
                onRefresh: () async {
                  historyController.fetchHistory();
                },
                child: historyController.historyList.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 100),
                          Center(child: Text("Belum ada riwayat.")),
                        ],
                      )
                    : ListView.builder(
                        itemCount: historyController.historyList.length,
                        itemBuilder: (context, index) {
                          final item = historyController.historyList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(Icons.history,
                                        color: Colors.pinkAccent, size: 32),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.note,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text(
                                            historyController
                                                .formatDate(item.timestamp),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              );
            }),

            // Tab 2: Log Aktivitas + Grafik
            Obx(() {
              final Map<String, int> actionCounts = {};
              for (var log in accountingController.logs) {
                actionCounts[log.action] = (actionCounts[log.action] ?? 0) + 1;
              }

              final actions = actionCounts.keys.toList();
              final barGroups = List.generate(actions.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                        toY: actionCounts[actions[i]]!.toDouble(),
                        color: Colors.pinkAccent),
                  ],
                  showingTooltipIndicators: [0],
                );
              });

              return RefreshIndicator(
                onRefresh: () async {
                  accountingController.fetchAccountingLogs();
                },
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Grafik Aktivitas Pengguna',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 200,
                            child: BarChart(
                              BarChartData(
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final idx = value.toInt();
                                        return Text(
                                          idx < actions.length
                                              ? actions[idx]
                                              : '',
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: true)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                barGroups: barGroups,
                                gridData: FlGridData(show: true),
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Riwayat Log Aktivitas',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...accountingController.logs.map((log) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.event_note,
                                color: Colors.pinkAccent),
                            title: Text(log.action),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(log.detail),
                                const SizedBox(height: 4),
                                Text(
                                  accountingController
                                      .formatDate(log.timestamp),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }),

            // Tab 3: Deteksi Pose + Grafik
            Obx(() {
              final Map<String, int> labelCounts = {};
              for (var h in poseController.history) {
                final label = h.label.trim();
                labelCounts[label] = (labelCounts[label] ?? 0) + 1;
              }

              final labels = labelCounts.keys.toList();
              final colors = [
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple,
                Colors.teal,
                Colors.amber,
                Colors.indigo,
                Colors.cyan,
                Colors.redAccent,
                Colors.lightGreen
              ];

              final barGroups = List.generate(labels.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: labelCounts[labels[i]]!.toDouble(),
                      color: colors[i % colors.length],
                      width: 18,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              });

              return RefreshIndicator(
                onRefresh: () async {
                  poseController.fetchPoseHistory();
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (labelCounts.isNotEmpty) ...[
                      const Text(
                        'Grafik Jumlah Deteksi Pose',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: BarChart(
                          BarChartData(
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final idx = value.toInt();
                                    return Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        idx < labels.length ? labels[idx] : '',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            barGroups: barGroups,
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    const Text(
                      'Riwayat Deteksi Pose',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    ...poseController.history.map((item) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.accessibility,
                              color: Colors.pinkAccent),
                          title: Text(item.label.trim()),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Mode: ${item.mode}"),
                              const SizedBox(height: 4),
                              Text(
                                item.timestamp
                                    .toLocal()
                                    .toString()
                                    .replaceAll('T', ' ')
                                    .split('.')
                                    .first,
                                style: const TextStyle(
                                    fontSize: 12, fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
