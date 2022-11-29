import 'dart:async';
import 'dart:math';

import 'package:bouncing_square/images.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Random randomNumber = Random();
  int index = 0;
  Offset? _position;
  int _swipeCount = 0;

  //************************************ */
  void moveRight(int count) {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_swipeCount != count) {
        //Prevents moving to the right and changing direction to the left
        timer.cancel();
      }
      setState(() {
        _position = Offset(_position!.dx + 2, _position!.dy);
      });
      //Checks if the square hits the right edge
      if (_position!.dx > MediaQuery.of(context).size.width - 120) {
        timer.cancel();
        moveLeft(count);
      }
    });
  }

  //*************************************** */
  void moveLeft(int count) {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      //
      if (_swipeCount != count) {
        // Stop moving to the left
        timer.cancel();
      }

      setState(() {
        _position = Offset(_position!.dx - 2, _position!.dy);
      });
      //Checks if the square hits the left edge
      if (_position!.dx < 0) {
        timer.cancel();
        moveRight(count);
      }
    });
  }

  //*************************************** */
  void moveUp(int count) {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_swipeCount != count) {
        timer.cancel();
        //Stops moving to the up side
      }

      setState(() {
        _position = Offset(_position!.dx, _position!.dy - 2);
      });
      //Checks if the square hits the top edge
      if (_position!.dy < 0 ||
          _position!.dy > MediaQuery.of(context).size.height - 120) {
        timer.cancel();
        moveDown(count);
      }
    });
  }

//*************************************** */
  void moveDown(int count) {
    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      //
      if (_swipeCount != count) {
        timer.cancel();
        //Stops moving to the bottom direction
      }
      setState(() {
        _position = Offset(_position!.dx, _position!.dy + 2);
      });
      //Checks if the square hits the bottom edge
      if (_position!.dy > MediaQuery.of(context).size.height - 120) {
        timer.cancel();
        moveUp(count);
      }
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _position ??= Offset((size.width - 120) / 2, (size.height - 120) / 2);
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            // Detecting the right and left swipes
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                _swipeCount++;
                moveRight(_swipeCount);
              } else if (details.primaryVelocity! < 0) {
                _swipeCount++;
                //Swipe left detected
                moveLeft(_swipeCount);
              }
            },
            // Detecting the up and dowm swipes
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                // Up swipe detected
                _swipeCount++;
                moveUp(_swipeCount);
              } else if (details.primaryVelocity! > 0) {
                //Down swipe detected
                _swipeCount++;
                moveDown(_swipeCount);
              }
            },
            //Long press to stop the square from moving
            onLongPress: () {
              _swipeCount++; // Timer cancelled
              setState(() {
                _position =
                    Offset((size.width - 120) / 2, (size.height - 120) / 2);
              });
            },
          ),
          Positioned(
            left: _position!.dx,
            top: _position!.dy,
            child: InkWell(
              onTap: () {
                setState(() {
                  index = randomNumber.nextInt(5);
                });
              },
              child: Container(
                height: 120,
                width: 120,
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(
                    IMAGE_LIST[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
