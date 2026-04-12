import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../app/providers/db_providers.dart';
import '../../data/local/database.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  String? _selectedEyeSide;
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(testSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('历史记录'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: sessionsAsync.when(
        data: (sessions) {
          final filteredSessions = _filterSessions(sessions);

          if (filteredSessions.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredSessions.length,
            itemBuilder: (context, index) {
              final session = filteredSessions[index];
              return _buildSessionCard(session);
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                '加载失败: $error',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(testSessionsProvider),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无测试记录',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '完成视力测试后，记录将显示在这里',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(TestSessionRow session) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final eyeSideText = _getEyeSideText(session.eyeSide);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showSessionDetail(session),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getEyeSideIcon(session.eyeSide),
                        color: _getEyeSideColor(session.eyeSide),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        eyeSideText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dateFormat.format(session.startedAt),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildAcuityItem(
                      label: '小数视力',
                      value: session.decimalAcuity != null
                          ? session.decimalAcuity!.toStringAsFixed(2)
                          : '--',
                    ),
                  ),
                  Expanded(
                    child: _buildAcuityItem(
                      label: '五分制',
                      value: session.fivePointAcuity != null
                          ? session.fivePointAcuity!.toStringAsFixed(2)
                          : '--',
                    ),
                  ),
                  Expanded(
                    child: _buildAcuityItem(
                      label: '正确率',
                      value: session.accuracy != null
                          ? '${(session.accuracy! * 100).toStringAsFixed(0)}%'
                          : '--',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.quiz_outlined,
                    label: '${session.totalQuestions}题',
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.check_circle_outline,
                    label: '${session.correctQuestions}正确',
                  ),
                  if (session.retestRecommended) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.warning_amber,
                      label: '建议重测',
                      color: Colors.orange,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcuityItem({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? Colors.blue).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color ?? Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('筛选记录'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('眼别'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('全部'),
                  selected: _selectedEyeSide == null,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedEyeSide = null);
                      Navigator.pop(context);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('左眼'),
                  selected: _selectedEyeSide == 'left',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedEyeSide = 'left');
                      Navigator.pop(context);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('右眼'),
                  selected: _selectedEyeSide == 'right',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedEyeSide = 'right');
                      Navigator.pop(context);
                    }
                  },
                ),
                ChoiceChip(
                  label: const Text('双眼'),
                  selected: _selectedEyeSide == 'both',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedEyeSide = 'both');
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('日期范围'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  initialDateRange: _selectedDateRange,
                );
                if (range != null) {
                  setState(() => _selectedDateRange = range);
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDateRange != null
                          ? '${DateFormat('MM/dd').format(_selectedDateRange!.start)} - ${DateFormat('MM/dd').format(_selectedDateRange!.end)}'
                          : '选择日期范围',
                    ),
                    if (_selectedDateRange != null)
                      GestureDetector(
                        onTap: () {
                          setState(() => _selectedDateRange = null);
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close, size: 18),
                      )
                    else
                      const Icon(Icons.calendar_today, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.invalidate(testSessionsProvider);
            },
            child: const Text('应用'),
          ),
        ],
      ),
    );
  }

  void _showSessionDetail(TestSessionRow session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => _SessionDetailSheet(
          session: session,
          scrollController: scrollController,
        ),
      ),
    );
  }

  List<TestSessionRow> _filterSessions(List<TestSessionRow> sessions) {
    var filtered = sessions;

    if (_selectedEyeSide != null) {
      filtered = filtered
          .where((s) => s.eyeSide == _selectedEyeSide)
          .toList();
    }

    if (_selectedDateRange != null) {
      filtered = filtered.where((s) {
        return s.startedAt.isAfter(_selectedDateRange!.start) &&
            s.startedAt.isBefore(
                _selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }

    return filtered;
  }

  String _getEyeSideText(String eyeSide) {
    switch (eyeSide) {
      case 'left':
        return '左眼';
      case 'right':
        return '右眼';
      case 'both':
        return '双眼';
      default:
        return eyeSide;
    }
  }

  IconData _getEyeSideIcon(String eyeSide) {
    switch (eyeSide) {
      case 'left':
        return Icons.visibility;
      case 'right':
        return Icons.visibility;
      case 'both':
        return Icons.remove_red_eye;
      default:
        return Icons.visibility;
    }
  }

  Color _getEyeSideColor(String eyeSide) {
    switch (eyeSide) {
      case 'left':
        return Colors.blue;
      case 'right':
        return Colors.green;
      case 'both':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}

class _SessionDetailSheet extends StatelessWidget {
  final TestSessionRow session;
  final ScrollController scrollController;

  const _SessionDetailSheet({
    required this.session,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');

    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        controller: scrollController,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '测试详情',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildDetailSection('基本信息', [
            _buildDetailRow('测试时间', dateFormat.format(session.startedAt)),
            _buildDetailRow('眼别', _getEyeSideText(session.eyeSide)),
            _buildDetailRow('测试模式', _getTestModeText(session.testMode)),
            _buildDetailRow('测试距离', '${session.testDistanceMm} mm'),
            _buildDetailRow('结束原因', _getEndReasonText(session.endReason)),
          ]),
          const SizedBox(height: 16),
          _buildDetailSection('视力结果', [
            _buildDetailRow(
              '小数视力',
              session.decimalAcuity != null
                  ? session.decimalAcuity!.toStringAsFixed(2)
                  : '--',
            ),
            _buildDetailRow(
              '五分制对数',
              session.fivePointAcuity != null
                  ? session.fivePointAcuity!.toStringAsFixed(2)
                  : '--',
            ),
            _buildDetailRow(
              'LogMAR',
              session.estimatedLogMar != null
                  ? session.estimatedLogMar!.toStringAsFixed(2)
                  : '--',
            ),
          ]),
          const SizedBox(height: 16),
          _buildDetailSection('测试统计', [
            _buildDetailRow('总题数', '${session.totalQuestions}'),
            _buildDetailRow('正确数', '${session.correctQuestions}'),
            _buildDetailRow(
              '正确率',
              session.accuracy != null
                  ? '${(session.accuracy! * 100).toStringAsFixed(1)}%'
                  : '--',
            ),
            _buildDetailRow(
              '平均响应时间',
              session.meanResponseTimeMs != null
                  ? '${session.meanResponseTimeMs!.toStringAsFixed(0)} ms'
                  : '--',
            ),
          ]),
          const SizedBox(height: 16),
          _buildDetailSection('测试配置', [
            _buildDetailRow('起始 LogMAR', session.startLogMar.toStringAsFixed(2)),
            _buildDetailRow('最小 LogMAR', session.minLogMar.toStringAsFixed(2)),
            _buildDetailRow('最大 LogMAR', session.maxLogMar.toStringAsFixed(2)),
            _buildDetailRow('步进', session.stepLogMar.toStringAsFixed(2)),
            _buildDetailRow('最大题数', '${session.maxQuestionCount}'),
          ]),
          if (session.retestRecommended) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 8),
                  Text(
                    '建议重新测试以获得更准确的结果',
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getEyeSideText(String eyeSide) {
    switch (eyeSide) {
      case 'left':
        return '左眼';
      case 'right':
        return '右眼';
      case 'both':
        return '双眼';
      default:
        return eyeSide;
    }
  }

  String _getTestModeText(String testMode) {
    switch (testMode) {
      case 'isolated':
        return '单字模式';
      case 'crowded':
        return '拥挤模式';
      default:
        return testMode;
    }
  }

  String _getEndReasonText(String endReason) {
    switch (endReason) {
      case 'thresholdReached':
        return '达到阈值';
      case 'maxQuestionsReached':
        return '达到最大题数';
      case 'bestAcuityReached':
        return '达到最佳视力上限';
      case 'pixelLimitReached':
        return '达到像素限制';
      case 'userAborted':
        return '用户中止';
      default:
        return endReason;
    }
  }
}
