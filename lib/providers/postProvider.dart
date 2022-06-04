// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gotour/models/PostModel.dart';
import 'package:gotour/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostProvider with ChangeNotifier {
  // Future get futurePosts => _futurePosts;
  // Future get futureHotels => _futureHotels;
  // Future get futureAdventures => _futureAdventures;
  //
  // PostDataBaseManager postDataBaseManager = PostDataBaseManager();
  //
  // final Future _futurePosts = PostDataBaseManager().getPosts("");
  // final Future _futureHotels = PostDataBaseManager().getPosts("Hotel");
  // final Future _futureAdventures = PostDataBaseManager().getPosts("Adventure");

  updatePostsDB() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastPost = prefList.isEmpty ? 0 : prefList.last.timestamp;

    //var lastPost = await postDataBaseManager.getTimestamp();

    if (lastPost == 0) {
      await postsReference
          .where("timestamp",
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy("timestamp", descending: true)
          .limit(10)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    } else {
      await postsReference
          .where("timestamp", isGreaterThan: lastPost)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    }

    //notifyListeners();
  }

  updateDestinationPosts(String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastTime = prefList
            .where((post) => post.city == city && post.country == country)
            .toList()
            .isEmpty
        ? 0
        : prefList
            .where((post) => post.city == city && post.country == country)
            .toList()
            .last
            .timestamp;

    // var lastTime = await postDataBaseManager.getLatestDestinationPost(
    //     widget.destination.city, widget.destination.country, 'DESC');

    if (lastTime == 0) {
      await postsReference
          .where("city", isEqualTo: city)
          .where("country", isEqualTo: country)
          .where("timestamp",
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    } else {
      await postsReference
          .where("city", isEqualTo: city)
          .where("country", isEqualTo: country)
          .where("timestamp", isGreaterThan: lastTime)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });
        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    }
  }

  Future<List<Post>> getLocalityPosts(
      String type, String locality, String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (type.isEmpty) {
      return prefList
          .where((post) =>
              post.locality == locality &&
              post.city == city &&
              post.country == country)
          .toList()
          .reversed
          .toList();
    } else {
      return prefList
          .where((post) =>
              post.type == type &&
              post.locality == locality &&
              post.city == city &&
              post.country == country)
          .toList()
          .reversed
          .toList();
    }
  }

  loadOldLocalityPosts(String locality, String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastPost = prefList
            .where((post) =>
                post.locality == locality &&
                post.city == city &&
                post.country == country)
            .toList()
            .isEmpty
        ? 0
        : prefList
            .where((post) =>
                post.locality == locality &&
                post.city == city &&
                post.country == country)
            .toList()
            .first
            .timestamp;

    await postsReference
        .where("locality", isEqualTo: locality)
        .where("country", isEqualTo: country)
        .where("city", isEqualTo: city)
        .where("timestamp", isLessThan: lastPost)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Post post = Post.fromDocument(document);

        prefList.add(post);
      });
      final String encodedData = Post.encode(prefList);

      await prefs.setString("posts", encodedData);

      notifyListeners();
    });
  }

  updateLocalityPosts(String locality, String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastPost = prefList
            .where((post) =>
                post.locality == locality &&
                post.city == city &&
                post.country == country)
            .toList()
            .isEmpty
        ? 0
        : prefList
            .where((post) =>
                post.locality == locality &&
                post.city == city &&
                post.country == country)
            .toList()
            .last
            .timestamp;

    if (lastPost == 0) {
      await postsReference
          .where("locality", isEqualTo: locality)
          .where("country", isEqualTo: country)
          .where("city", isEqualTo: city)
          .where("timestamp",
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    } else {
      await postsReference
          .where("locality", isEqualTo: locality)
          .where("country", isEqualTo: country)
          .where("city", isEqualTo: city)
          .where("timestamp", isGreaterThan: lastPost)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    }
  }

  Future<List<Post>> getDestinationPosts(
      String type, String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (type.isEmpty) {
      return prefList
          .where((post) => post.city == city && post.country == country)
          .toList()
          .reversed
          .toList();
    } else {
      return prefList
          .where((post) =>
              post.city == city && post.country == country && post.type == type)
          .toList()
          .reversed
          .toList();
    }
  }

  loadOldDestinationPosts(String city, String country) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastTime = prefList
            .where((post) => post.city == city && post.country == country)
            .toList()
            .isEmpty
        ? 0
        : prefList
            .where((post) => post.city == city && post.country == country)
            .toList()
            .first
            .timestamp;

    await postsReference
        .where("city", isEqualTo: city)
        .where("country", isEqualTo: country)
        .where("timestamp", isLessThan: lastTime)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Post post = Post.fromDocument(document);

        prefList.add(post);
      });

      final String encodedData = Post.encode(prefList);

      await prefs.setString("posts", encodedData);

      notifyListeners();
    });
  }

  updateUserPost(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("userPosts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastUserPost =
        prefList.where((post) => post.userId == userId).toList().isEmpty
            ? 0
            : prefList
                .where((post) => post.userId == userId)
                .toList()
                .last
                .timestamp;

    // var lastUserPost =
    // await _postDataBaseManager.getLastUserPost(widget.userId, 'DESC');

    if (lastUserPost == 0) {
      await postsReference
          .where("ownerId", isEqualTo: userId)
          //.where("timestamp", isGreaterThan: lastUserPost)
          .orderBy("timestamp", descending: true)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("userPosts", encodedData);

        notifyListeners();
      });
    } else {
      await postsReference
          .where("ownerId", isEqualTo: userId)
          .where("timestamp", isGreaterThan: lastUserPost)
          .orderBy("timestamp", descending: false)
          .limit(5)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("userPosts", encodedData);

        notifyListeners();
      });
    }
  }

  Future<List<Post>> getUserPosts(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("userPosts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return prefList.reversed.where((post) => post.userId == userId).toList();
  }

  loadOldUserPosts(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("userPosts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastUserPost =
        prefList.where((post) => post.userId == userId).toList().isEmpty
            ? 0
            : prefList
                .where((post) => post.userId == userId)
                .toList()
                .first
                .timestamp;

    // var lastUserPost =
    // await _postDataBaseManager.getLastUserPost(widget.userId, 'ASC');

    await postsReference
        .where("ownerId", isEqualTo: userId)
        .where("timestamp", isLessThan: lastUserPost)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Post post = Post.fromDocument(document);

        prefList.add(post);
      });

      final String encodedData = Post.encode(prefList);

      await prefs.setString("userPosts", encodedData);

      notifyListeners();
    });
  }

  updateCategoryPosts(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastPost = prefList.where((post) => post.type == type).toList().isEmpty
        ? 0
        : prefList.where((post) => post.type == type).toList().last.timestamp;

    // var lastPost =
    // await postDataBaseManager.getLastCategoryPost(widget.title, 'DESC');

    if (lastPost == 0) {
      await postsReference
          .where("type", isEqualTo: type)
          .where("timestamp",
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy("timestamp", descending: true)
          .limit(7)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    } else {
      await postsReference
          .where("type", isEqualTo: type)
          .where("timestamp", isGreaterThan: lastPost)
          .orderBy("timestamp", descending: false)
          .limit(7)
          .get()
          .then((querySnapshot) async {
        querySnapshot.docs.forEach((document) async {
          Post post = Post.fromDocument(document);

          prefList.add(post);
        });

        final String encodedData = Post.encode(prefList);

        await prefs.setString("posts", encodedData);

        notifyListeners();
      });
    }
  }

  Future<List<Post>> getCategoryPosts(String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return prefList.reversed.where((post) => post.type == type).toList();
  }

  loadOldCategoryPosts(String type) async {
    // lastPost is assumed to be greater than 0

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String postsString = prefs.getString("posts") ?? "";

    List<Post> prefList = Post.decode(postsString);

    prefList.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    var lastPost = prefList.where((post) => post.type == type).toList().isEmpty
        ? 0
        : prefList.where((post) => post.type == type).toList().first.timestamp;

    await postsReference
        .where("type", isEqualTo: type)
        .where("timestamp", isLessThan: lastPost)
        .orderBy("timestamp", descending: true)
        .limit(5)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((document) async {
        Post post = Post.fromDocument(document);

        prefList.add(post);
      });

      final String encodedData = Post.encode(prefList);

      await prefs.setString("posts", encodedData);

      notifyListeners();
    });
  }
}
