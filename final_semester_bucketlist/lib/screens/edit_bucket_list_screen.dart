import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bucket_list_provider.dart';
import '../models/bucket_list_item.dart';

class EditBucketListScreen extends StatefulWidget {
  final BucketListItem? item;

  const EditBucketListScreen({Key? key, this.item}) : super(key: key);

  @override
  State<EditBucketListScreen> createState() => _EditBucketListScreenState();
}

class _EditBucketListScreenState extends State<EditBucketListScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _targetDate;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _titleController.text = widget.item!.title;
      _descriptionController.text = widget.item!.description ?? '';
      _targetDate = widget.item!.targetDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? '새로운 목표' : '목표 수정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Semantics(
              label: '목표 제목 입력',
              hint: '달성하고 싶은 목표의 제목을 입력하세요',
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: '제목',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
              ),
            ),
            SizedBox(height: 16),
            Semantics(
              label: '목표 설명 입력',
              hint: '목표에 대한 자세한 설명을 입력하세요 (선택사항)',
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: '설명 (선택사항)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            SizedBox(height: 16),
            Semantics(
              label: '목표 날짜 선택',
              hint: '목표를 달성하고 싶은 날짜를 선택하세요',
              child: ListTile(
                title: Text('목표 날짜'),
                subtitle: Text(_targetDate == null
                    ? '날짜 선택'
                    : '${_targetDate!.year}년 ${_targetDate!.month}월 ${_targetDate!.day}일'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _targetDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365 * 10)),
                  );
                  if (date != null) {
                    setState(() => _targetDate = date);
                  }
                },
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Semantics(
                label: '저장하기',
                hint: '입력한 목표 정보를 저장합니다',
                child: ElevatedButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('제목을 입력해주세요')),
                      );
                      return;
                    }

                    final provider = context.read<BucketListProvider>();
                    if (widget.item == null) {
                      provider.addItem(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        targetDate: _targetDate,
                      );
                    } else {
                      provider.updateItem(
                        widget.item!.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        targetDate: _targetDate,
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('저장하기'),
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