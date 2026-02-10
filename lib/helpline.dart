import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  const HelpPage({
    super.key,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _filteredDistricts;

  final List<Map<String, dynamic>> districts = [
    // Add your full districts list here...
    {
      'district': 'Alappuzha',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9495003640'},
          {'name': 'District Collector', 'number': '9447129011'},
          {'name': 'Dy. Collector (DM)', 'number': '8547610047'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996982'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920114'},
        ],
        'Fisheries': [
          {'name': 'DD Fisheries', 'number': '9496007028'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer, Health', 'number': '9946105477'},
        ],
      },
    },
    {
      'district': 'Ernakulam',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room (DEOC)', 'number': '9400021077'},
          {'name': 'District Collector', 'number': '9447729012'},
          {'name': 'Dy. Collector (DM)', 'number': '8547610077'},
        ],
        'Police': [
          {
            'name': 'Police Commissioner Kochi City Police',
            'number': '9497996990',
          },
        ],
        'Fire and Rescue Service': [
          {'name': 'Regional Fire Officer', 'number': '9497920105'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105483'},
        ],
      },
    },
    {
      'district': 'Idukki',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9383463036'},
          {'name': 'District Collector', 'number': '9447032252'},
          {'name': 'Dy. Collector & A.D.M', 'number': '8547610061'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996981'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920116'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer', 'number': '9946105481'},
        ],
      },
    },
    {
      'district': 'Kannur',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9446682300'},
          {'name': 'District Collector', 'number': '9447029015'},
          {'name': 'Deputy Collector DM', 'number': '8547616034'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996900'},
        ],
        'Fire and Rescue Service': [
          {'name': 'Fire and Rescue Station Officer', 'number': '9497920238'},
        ],
        'Fisheries': [
          {'name': 'Deputy Director', 'number': '9496007033'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105495'},
        ],
      },
    },
    {
      'district': 'Kasaragod',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9446601700'},
          {'name': 'District Collector', 'number': '9447496600'},
          {'name': 'Dy. Collector & A.D.M', 'number': '9447726900'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '0499-4257401'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920123'},
        ],
        'Fisheries': [
          {'name': 'Deputy Director', 'number': '0467-2202537'},
        ],
        'KSEB': [
          {'name': 'Dy. Chief Engineer', 'number': '9446008345'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105497'},
        ],
      },
    },
    {
      'district': 'Kollam',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9447677800'},
          {'name': 'District Collector', 'number': '9447795500'},
          {'name': 'Dy. Collector & A.D.M', 'number': '8547610026'},
        ],
        'Police': [
          {
            'name': 'District Police Chief Kollam Rural',
            'number': '9497996908',
          },
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920111'},
        ],
        'Fisheries': [
          {'name': 'Dy. Director of Fisheries', 'number': '9496007027'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer, Health', 'number': '9946105473'},
        ],
      },
    },
    {
      'district': 'Kottayam',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9446562236'},
          {'name': 'District Collector', 'number': '9447029007'},
          {'name': 'Dy. Collector & A.D.M', 'number': '9446564800'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996980'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '0481-2567444'},
        ],
        'Fisheries': [
          {'name': 'Deputy Director, Fisheries', 'number': '9496155958'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105479'},
        ],
      },
    },
    {
      'district': 'Kozhikode',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9446538900'},
          {'name': 'District Collector', 'number': '9447171400'},
          {'name': 'Dy. Collector (DM)', 'number': '8547616018'},
        ],
        'Police': [
          {'name': 'Police Commissioner', 'number': '9497996989'},
        ],
        'Fire and Rescue Service': [
          {'name': 'Regional Fire Officer', 'number': '9497920107'},
        ],
        'Fisheries': [
          {'name': 'Director of Fisheries', 'number': '9496007032'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105491'},
        ],
      },
    },
    {
      'district': 'Malappuram',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9383464212'},
          {'name': 'District Collector', 'number': '9446539017'},
          {'name': 'Dy. Collector (DM)', 'number': '8547616007'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996976'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920119'},
        ],
        'Fisheries': [
          {'name': 'Dy Director, Ponnani', 'number': '9496007031'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer', 'number': '0483-2737857'},
        ],
      },
    },
    {
      'district': 'Palakkad',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '8921994727'},
          {'name': 'District Collector', 'number': '8547610100'},
          {'name': 'Dy. Collector A.D.M', 'number': '8547610093'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996977'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920167'},
        ],
        'Fisheries': [
          {'name': 'Dy. Director of Fisheries', 'number': '9496007050'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105487'},
        ],
      },
    },
    {
      'district': 'Pathanamthitta',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '8078808915'},
          {'name': 'District Collector', 'number': '9447029008'},
          {
            'name': 'Dy. Collector (Disaster Management)',
            'number': '8547610039',
          },
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996983'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920112'},
        ],
        'Fisheries': [
          {'name': 'Assistant Director', 'number': '8921031800'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer', 'number': '9946105475'},
        ],
      },
    },
    {
      'district': 'Thiruvananthapuram',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9497711281'},
          {'name': 'District Collector', 'number': '9447700222'},
          {'name': 'Dy. Collector & ADM', 'number': '8547610101'},
        ],
        'Police': [
          {'name': 'Control Room (City)', 'number': '9497960211'},
          {'name': 'District Police Chief', 'number': '9497996991'},
          {'name': 'Deputy Commissioner Law and Order', 'number': '9497996988'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920110'},
        ],
        'Fisheries': [
          {'name': 'Deputy Director of Fisheries', 'number': '9496007026'},
        ],
        'KSEB': [
          {
            'name': 'Chief Engineer, Transmission south',
            'number': '9446008010',
          },
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105472'},
        ],
        'KSRTC': [
          {'name': 'District Transport Office', 'number': '9447071092'},
        ],
      },
    },
    {
      'district': 'Thrissur',
      'categories': {
        'Revenue': [
          {'name': 'District Control Room', 'number': '9447074424'},
          {'name': 'District Collector', 'number': '9447129013'},
          {'name': 'Dy. Collector (DM)', 'number': '8547610089'},
        ],
        'Police': [
          {'name': 'Rural SP Office', 'number': '9497996978'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920117'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer', 'number': '0487-2333242'},
        ],
      },
    },
    {
      'district': 'Wayanad',
      'categories': {
        'Revenue': [
          {
            'name': 'District Emergency Control Room (DEOC)',
            'number': '8078409770',
          },
          {'name': 'District Collector', 'number': '9447204666'},
          {'name': 'Dy. Collector & A.D.M', 'number': '8547616021'},
        ],
        'Police': [
          {'name': 'District Police Chief', 'number': '9497996974'},
        ],
        'Fire and Rescue Service': [
          {'name': 'District Fire Officer', 'number': '9497920122'},
        ],
        'KSEB': [
          {'name': 'Deputy Chief Engineer', 'number': '9446008329'},
        ],
        'Health Services': [
          {'name': 'District Medical Officer (Health)', 'number': '9946105493'},
        ],
      },
    },

    // Add remaining districts here...
  ];

  @override
  void initState() {
    super.initState();
    _filteredDistricts = districts;
    _searchController.addListener(_filterDistricts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDistricts() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _filteredDistricts = districts);
      return;
    }

    final List<Map<String, dynamic>> results = [];
    for (final districtData in districts) {
      final districtName = districtData['district'].toString().toLowerCase();
      bool districtMatches = districtName.contains(query);

      if (!districtMatches) {
        final categories =
            districtData['categories']
                as Map<String, List<Map<String, String>>>;
        for (final categoryEntry in categories.entries) {
          if (categoryEntry.key.toLowerCase().contains(query)) {
            districtMatches = true;
            break;
          }
          for (final contact in categoryEntry.value) {
            if (contact['name']!.toLowerCase().contains(query) ||
                contact['number']!.contains(query)) {
              districtMatches = true;
              break;
            }
          }
          if (districtMatches) break;
        }
      }

      if (districtMatches) results.add(districtData);
    }

    setState(() => _filteredDistricts = results);
  }

  Future<void> _makeCall(String phoneNumber) async {
    final String numberToCall = phoneNumber.split(',')[0].trim();
    final Uri telUri = Uri(scheme: 'tel', path: numberToCall);

    try {
      if (!await launchUrl(telUri, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch dialer for $numberToCall');
      }
    } catch (e) {
      debugPrint('Error launching dialer: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color.fromARGB(255, 4, 4, 4)
          : Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by district, category, name...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredDistricts.length,
                itemBuilder: (context, index) {
                  final districtData = _filteredDistricts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          title: Text(
                            districtData['district'].toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          backgroundColor: isDark
                              ? const Color.fromARGB(255, 13, 13, 13)
                              : Colors.grey[100],
                          collapsedBackgroundColor: isDark
                              ? const Color.fromARGB(255, 1, 1, 1)
                              : Colors.grey[100],
                          trailing: Icon(
                            Icons.keyboard_arrow_down,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          children:
                              (districtData['categories']
                                      as Map<String, List<Map<String, String>>>)
                                  .entries
                                  .map<Widget>((categoryEntry) {
                                    return ExpansionTile(
                                      tilePadding: const EdgeInsets.only(
                                        left: 32.0,
                                        right: 16.0,
                                      ),
                                      title: Text(
                                        categoryEntry.key,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? const Color.fromARGB(
                                                  179,
                                                  230,
                                                  228,
                                                  228,
                                                )
                                              : Colors.black87,
                                        ),
                                      ),
                                      children: categoryEntry.value.map<Widget>(
                                        (contact) {
                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.only(
                                                  left: 48.0,
                                                  right: 16.0,
                                                ),
                                            title: Text(
                                              contact['name']!,
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                            subtitle: Text(
                                              contact['number']!,
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black54,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(
                                                Icons.call,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () =>
                                                  _makeCall(contact['number']!),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    );
                                  })
                                  .toList(),
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
