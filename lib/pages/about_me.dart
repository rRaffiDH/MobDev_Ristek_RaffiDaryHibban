import 'package:flutter/material.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('About Me'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile.jpg'), 
            ),
            const SizedBox(height: 16),
            
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            
            const Text(
              'Nickname: Johnny',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Hobbies: Photography, Traveling, Coding',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: () {
                    
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.link),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
