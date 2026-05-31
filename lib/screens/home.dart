// lib/screens/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/constants.dart';
import '../shared/player.dart';
import '../utils/theme.dart';
import 'features/drawer.dart';
import 'features/premium.dart';
import 'features/profile.dart';
import 'dashboard.dart';
import 'library.dart';
import 'search.dart';
import 'views/albumviewer.dart';
import 'views/artistviewer.dart';
import 'views/playlistviewer.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // per-tab navigators (3 real tabs: Home, Search, Library)
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  late final List<Widget> _navigators;

  @override
  void initState() {
    super.initState();
    _navigators = [
      _buildNavigator(const Dashboard(), _navigatorKeys[0]),
      _buildNavigator(const Search(), _navigatorKeys[1]),
      _buildNavigator(const LibraryPage(), _navigatorKeys[2]),
    ];
    loadProfiles();
  }

  Widget _buildNavigator(Widget page, GlobalKey<NavigatorState> key) {
    return Navigator(
      key: key,
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> pushToActiveTab(Widget page) async {
    final tabIndex = ref.read(tabIndexProvider);
    final currentKey = _navigatorKeys[tabIndex.clamp(0, 2)];
    final state = currentKey.currentState;
    if (state != null) {
      state.push(
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 100),
          reverseDuration: const Duration(milliseconds: 100),
          child: page,
        ),
      );
    } else {
      Navigator.of(context).push(
        PageTransition(
          type: PageTransitionType.rightToLeft,
          duration: const Duration(milliseconds: 100),
          reverseDuration: const Duration(milliseconds: 100),
          child: page,
        ),
      );
    }
  }

  void _showCreateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF282828),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _createOption(
                  icon: Icons.music_note,
                  title: 'Playlist',
                  subtitle: 'Create a playlist with songs or episodes',
                  onTap: () => Navigator.pop(ctx),
                ),
                _createOption(
                  icon: Icons.people_outline,
                  title: 'Collaborative playlist',
                  subtitle: 'Create a playlist together with friends',
                  onTap: () => Navigator.pop(ctx),
                ),
                _createOption(
                  icon: Icons.blur_on,
                  title: 'Blend',
                  subtitle: "Combine your friends' tastes into a playlist",
                  onTap: () => Navigator.pop(ctx),
                ),
                const SizedBox(height: 8),
                // Close button
                GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 22),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _createOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white12,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white54, fontSize: 13),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final tabIndex = ref.watch(tabIndexProvider);
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    ref.listen<PlayerNavCommand?>(playerNavProvider, (previous, command) {
      if (command == null) return;
      ref.read(tabIndexProvider.notifier).state = command.tabIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final Widget page = switch (command.type) {
          PlayerNavType.album => AlbumViewer(albumId: command.id),
          PlayerNavType.artist => ArtistViewer(artistId: command.id),
          PlayerNavType.playlist => PlaylistViewer(playlistId: command.id),
        };
        final navigator = _navigatorKeys[command.tabIndex.clamp(0, 2)].currentState;
        if (navigator != null) {
          navigator.push(
            PageTransition(
              type: PageTransitionType.rightToLeft,
              duration: const Duration(milliseconds: 200),
              child: page,
            ),
          );
        }
        ref.read(playerNavProvider.notifier).clear();
      });
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final safeIndex = tabIndex.clamp(0, 2);
        final currentKey = _navigatorKeys[safeIndex];
        final currentState = currentKey.currentState;
        if (currentState != null && currentState.canPop()) {
          currentState.pop();
          return;
        }
        if (tabIndex != 0) {
          ref.read(tabIndexProvider.notifier).state = 0;
          return;
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: SideDrawer(
          onNavigate: (page) async {
            Navigator.of(context).pop();
            await Future.delayed(const Duration(microseconds: 300));
            await pushToActiveTab(page);
          },
        ),
        body: Stack(
          children: [
            // Show Premium page when tab 3 is selected
            if (tabIndex == 3)
              const PremiumPage()
            else
              IndexedStack(
                index: tabIndex.clamp(0, 2),
                children: _navigators,
              ),
            if (!isKeyboardVisible)
              const Align(
                alignment: Alignment.bottomCenter,
                child: MiniPlayer(),
              ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(tabIndex),
      ),
    );
  }

  Widget _buildBottomNavBar(int tabIndex) {
    return Container(
      color: const Color(0xFF121212),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _navItem(
                index: 0,
                current: tabIndex,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              _navItem(
                index: 1,
                current: tabIndex,
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: 'Search',
              ),
              _navItem(
                index: 2,
                current: tabIndex,
                icon: Icons.library_music_outlined,
                activeIcon: Icons.library_music,
                label: 'Your Library',
              ),
              _navItem(
                index: 3,
                current: tabIndex,
                icon: Icons.workspace_premium_outlined,
                activeIcon: Icons.workspace_premium,
                label: 'Premium',
              ),
              // Create button — no tab index, opens sheet
              Expanded(
                child: GestureDetector(
                  onTap: _showCreateSheet,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_box_outlined,
                        color: Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Create',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required int current,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = current == index;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          if (index == current && index < 3) {
            _navigatorKeys[index].currentState?.popUntil((r) => r.isFirst);
          } else {
            ref.read(tabIndexProvider.notifier).state = index;
            final prefs = await SharedPreferences.getInstance();
            prefs.setInt('last_index', index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? spotifyGreen : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? spotifyGreen : Colors.grey,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: spotifyGreen,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
