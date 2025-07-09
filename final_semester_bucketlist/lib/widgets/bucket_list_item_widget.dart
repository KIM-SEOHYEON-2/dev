import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/bucket_list_item.dart';
import '../screens/edit_bucket_list_screen.dart';
import 'package:provider/provider.dart';
import '../providers/bucket_list_provider.dart';

class BucketListItemWidget extends StatelessWidget {
  final BucketListItem item;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final Function(DragUpdateDetails)? onDragUpdate;

  const BucketListItemWidget({
    Key? key,
    required this.item,
    required this.onToggle,
    required this.onTap,
    this.onDragUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<BucketListItem>(
      data: item,
      feedback: Material(
        elevation: 4,
        child: Container(
          width: MediaQuery.of(context).size.width - 32,
          child: Card(
            child: ListTile(
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCard(context),
      ),
      child: DragTarget<BucketListItem>(
        onWillAccept: (receivedItem) => receivedItem != null && receivedItem != item,
        onAccept: (receivedItem) {
          // 순서 변경 로직은 provider에서 처리
        },
        builder: (context, candidateData, rejectedData) => _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            decoration: item.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: item.description?.isNotEmpty == true
            ? Text(
                item.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                ),
              )
            : null,
        leading: Semantics(
          label: item.isCompleted ? '완료된 목표' : '미완료 목표',
          child: Checkbox(
            value: item.isCompleted,
            onChanged: (_) => onToggle(),
          ),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text('수정'),
              onTap: onTap,
            ),
            PopupMenuItem(
              child: Text('삭제'),
              onTap: () {
                // 삭제 로직
              },
            ),
          ],
        ),
      ),
    );
  }
} 