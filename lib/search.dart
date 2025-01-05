import 'package:flutter/material.dart';

import 'job.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? selectedSkill;
  String? selectedLocation;
  String? selectedSalaryRange;
  String? selectedExperienceLevel;
  String? selectedJobType;

  List<Job> filteredJobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  void fetchJobs() {
    updateJobs((success) {
      if (success) {
        setState(() {
          isLoading = false;
          filteredJobs = [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load job listings')),
        );
      }
    });
  }

  void updateFilteredJobs() {
    setState(() {
      filteredJobs = jobs.where((job) {
        final matchesSkill = selectedSkill == null ||
            job.skillsRequired
                .split(',')
                .map((skill) => skill.trim().toLowerCase())
                .contains(selectedSkill?.toLowerCase());
        final matchesLocation = selectedLocation == null ||
            job.location.toLowerCase() == selectedLocation?.toLowerCase();
        final matchesSalary = selectedSalaryRange == null ||
            (selectedSalaryRange == '< \$50,000' && job.salary < 50000) ||
            (selectedSalaryRange == '\$50,000 - \$100,000' &&
                job.salary >= 50000 &&
                job.salary <= 100000) ||
            (selectedSalaryRange == '> \$100,000' && job.salary > 100000);
        final matchesExperience = selectedExperienceLevel == null ||
            job.experienceLevel.toLowerCase() ==
                selectedExperienceLevel?.toLowerCase();
        final matchesJobType = selectedJobType == null ||
            job.jobType.toLowerCase() == selectedJobType?.toLowerCase();

        return matchesSkill &&
            matchesLocation &&
            matchesSalary &&
            matchesExperience &&
            matchesJobType;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<String> allSkills = [];
    // here we did .split because in our data base the skills are separated by comma
    for (var job in jobs) {
      List<String> skillsList =
          job.skillsRequired.split(',').map((skill) => skill.trim()).toList();
      allSkills.addAll(skillsList);
    }
    allSkills = allSkills
        .toSet()
        .toList(); // Dr. here we used .toSet() to Remove duplicates

    List<String> allLocations =
        jobs.map((job) => job.location).toSet().toList();
    List<String> allExperienceLevels =
        jobs.map((job) => job.experienceLevel).toSet().toList();
    List<String> allJobTypes = jobs.map((job) => job.jobType).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Job Search'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Skill Dropdown Menu
                  SizedBox(
                    width: screenWidth,
                    child: DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: null,
                      hintText: "Search By skill",
                      dropdownMenuEntries:
                          allSkills.map<DropdownMenuEntry<String>>((skill) {
                        return DropdownMenuEntry(value: skill, label: skill);
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedSkill = value;
                          updateFilteredJobs();
                        });
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(), // Add border styling
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location Dropdown Menu
                  SizedBox(
                    width: screenWidth,
                    child: DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: null,
                      hintText: "Search By Location",
                      dropdownMenuEntries: allLocations
                          .map<DropdownMenuEntry<String>>((location) {
                        return DropdownMenuEntry(
                            value: location, label: location);
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedLocation = value;
                          updateFilteredJobs();
                        });
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Salary Range Dropdown Menu
                  SizedBox(
                    width: screenWidth,
                    child: DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: null,
                      hintText: "Choose a salary range",
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(
                            value: '< \$50,000', label: '< \$50,000'),
                        DropdownMenuEntry(
                            value: '\$50,000 - \$100,000',
                            label: '\$50,000 - \$100,000'),
                        DropdownMenuEntry(
                            value: '> \$100,000', label: '> \$100,000'),
                      ],
                      onSelected: (value) {
                        setState(() {
                          selectedSalaryRange = value;
                          updateFilteredJobs();
                        });
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Experience Level Dropdown Menu
                  SizedBox(
                    width: screenWidth,
                    child: DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: null,
                      hintText: "Search by experience level",
                      dropdownMenuEntries: allExperienceLevels
                          .map<DropdownMenuEntry<String>>((level) {
                        return DropdownMenuEntry(value: level, label: level);
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedExperienceLevel = value;
                          updateFilteredJobs();
                        });
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Job Type Dropdown Menu
                  SizedBox(
                    width: screenWidth,
                    child: DropdownMenu<String>(
                      width: screenWidth,
                      initialSelection: null,
                      hintText: "Search by job type",
                      dropdownMenuEntries:
                          allJobTypes.map<DropdownMenuEntry<String>>((type) {
                        return DropdownMenuEntry(value: type, label: type);
                      }).toList(),
                      onSelected: (value) {
                        setState(() {
                          selectedJobType = value;
                          updateFilteredJobs();
                        });
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Jobs List
                  Expanded(
                    child: filteredJobs.isEmpty
                        ? const Center(
                            child: Text(
                                'No jobs found. Please refine your search.'),
                          )
                        : ListView.builder(
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              final job = filteredJobs[index];
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(job.title),
                                  subtitle: Text(
                                      'Location: ${job.location}, Salary: \$${job.salary}'),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Applied for ${job.title}!')),
                                      );
                                    },
                                    child: const Text(
                                      'Apply',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
