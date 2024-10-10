import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _controller = TextEditingController();

  final List<String> _operators = ['+', '-', '×', '÷'];

  final List<String> _keys = [
    '7', '8', '9', '÷',
    '4', '5', '6', '×',
    '1', '2', '3', '-',
    '0', '.', '⌫', '+',
  ];

  void _onKeyPress(String key) {
    setState(() {
      if (key == '⌫') {
        if (_controller.text.isNotEmpty) {
          _controller.text = _controller.text.substring(0, _controller.text.length - 1);
        }
      } else {
        _controller.text += key;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('入力問題'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(

                    //あとから問題入れる
                    children: List.generate(30, (index) =>
                    Text(
                      'テキスト ${index + 1}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    )
                    ),
                    //ここまで

                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: TextFormField(
              controller: _controller,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '式を入力してください',
              ),
              style: const TextStyle(fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              color: Colors.grey[200],
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _keys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 3.0,
                  crossAxisSpacing: 20.0,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  String key = _keys[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _operators.contains(key)
                          ? Colors.orange
                          : (key == '⌫'
                          ? Colors.red
                          : Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () => _onKeyPress(key),
                    child: Text(
                      key,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
