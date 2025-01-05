import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

const String baseURL = 'aishakotob.atwebpages.com';

class Job {
  final int id;
  final String title;
  final String location;
  final double salary;
  final String description;
  final String skillsRequired;
  final String experienceLevel;
  final String jobType;

  Job(this.id, this.title, this.location, this.salary, this.description,
      this.skillsRequired, this.experienceLevel, this.jobType);

  @override
  String toString() {
    return 'Job ID: $id\nTitle: $title\nLocation: $location\nSalary: $salary\nExperience: $experienceLevel\nJob Type: $jobType\nSkills: $skillsRequired\nDescription: $description';
  }
}

List<Job> jobs = [];

void updateJobs(Function(bool) callback) async {
  jobs.clear();
  try {
    final url = Uri.http(baseURL, 'getJobs.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      final jobList = convert.jsonDecode(response.body);
      for (var row in jobList) {
        Job job = Job(
          int.parse(row['job_id']),
          row['title'],
          row['location'],
          double.parse(row['salary']),
          row['description'],
          row['skills_required'],
          row['experience_level'],
          row['job_type'],
        );
        jobs.add(job);
      }
      callback(true);
    } else {
      callback(false);
    }
  } catch (e) {
    callback(false);
  }
}
