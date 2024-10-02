import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScoreUmpireApp extends StatefulWidget {
  @override
  _ScoreUmpireAppState createState() => _ScoreUmpireAppState();
}

class _ScoreUmpireAppState extends State<ScoreUmpireApp> {
  String battingTeam = "India"; // Default batting team
  int runs = 0;
  int wickets = 0;
  bool isLoading = false;

  final String baseUrl = "https://cricketlivescore.onrender.com";

  // Function to initialize the match
  Future<void> initializeMatch() async {
    final url = Uri.parse('$baseUrl/initialize');
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'batting_team': battingTeam}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          runs = data['runs'];
          wickets = data['wickets'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match initialized successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize match: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error initializing match: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing match: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to update the score
  Future<void> updateScore(int run, bool isWicket) async {
    final url = Uri.parse('$baseUrl/update-score');
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'batting_team': battingTeam, 'run': run, 'isWicket': isWicket}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          runs = data['runs'];
          wickets = data['wickets'];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Score updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update score: ${response.body}')),
        );
      }
    } catch (error) {
      print('Error updating score: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating score: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Cricket Score Board",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Batting Team: $battingTeam',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Text(
                      '$runs/$wickets',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Runs:', style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [1, 2, 3, 4, 5, 6, 7]
                          .map((run) => ElevatedButton(
                        onPressed: () => updateScore(run, false),
                        child: Text('$run'),
                      ))
                          .toList(),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => updateScore(0, true), // 0 runs means only wicket is incremented
                  child: Text('Wicket'),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            child: Image.asset(
              'assets/cricket.png',
              width: 300,
              height:300,
            ),
          ),
        ],
      ),
    );
  }
}
