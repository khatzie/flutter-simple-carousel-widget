// Simple Carousel Widgets
// By: Katherine Petalio-Amar

import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  const Carousel({
    Key? key,
    required this.width,
    required this.height,
    required this.content,
    this.showPagination = true,
    this.showNavigation = true,
    this.showCaption = true,
    this.navigationColor = Colors.white,
    this.paginationActiveColor = Colors.black87,
    this.captionColor = Colors.white,
  }) : super(key: key);

  final double width;
  final double height;
  final List<Map> content;
  final bool showPagination;
  final bool showNavigation;
  final bool showCaption;
  final Color navigationColor;
  final Color paginationActiveColor;
  final Color captionColor;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  ScrollController scrollController = ScrollController();
  int currentPage = 0;
  double currentOffset = 0;

  @override
  void initState() {
    scrollController.addListener(() {
      setState(() {
        currentOffset = scrollController.offset;
        currentPage = getActivePage(widget.width, currentOffset).toInt();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            SizedBox(
                height: widget.height,
                width: widget.width,
                child: ListView.builder(
                  physics: const PageScrollPhysics(),
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.content.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        SizedBox(
                          width: widget.width,
                          height: widget.height,
                          child: GestureDetector(
                            onTap: () => {},
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.fill,
                                    placeholder: 'assets/images/placeholder.jpeg',
                                    fadeInDuration: const Duration(milliseconds: 500),
                                    fadeOutDuration: const Duration(milliseconds: 500),
                                    image: widget.content[index]["imageUrl"],
                                  )),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.showCaption,
                          child: Positioned(
                          top: widget.height - 30,
                          child:  Container(
                            height: 30,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                            width: widget.width,
                            decoration: const BoxDecoration(
                                color: Colors.black38
                            ),
                            child: Text(
                              widget.content[index]['caption'],
                              style: TextStyle(
                                  color: widget.captionColor
                              ),
                            ),
                          ),
                        ),
                        )
                      ],
                    );
                  },
                )
            ),
            Visibility(
              visible: widget.showNavigation,
              child: Positioned(
                top: (widget.height - 30) / 2,
                left: 10,
                child: GestureDetector(
                  onTap: (){
                    setPrevious();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.only(left: 8),
                    decoration: const BoxDecoration(
                        color: Colors.black38
                    ),

                    child: Icon(Icons.arrow_back_ios, size: 20, color: widget.navigationColor),
                  ),
                )
              ),
            ),
            Visibility(
              visible: widget.showNavigation,
              child: Positioned(
                top: (widget.height - 30) / 2,
                right: 10,
                child: GestureDetector(
                  onTap: (){
                    setNext();
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        color: Colors.black38
                    ),
                    child: Icon(Icons.arrow_forward_ios, size: 20, color: widget.navigationColor),
                  ),
                )
              ),
            ),
          ],
        ),
        Visibility(
          visible: widget.showPagination,
          child: SizedBox(
              height: 25,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.content.length; i++)
                    Container(
                      width: 10.0,
                      height: 10.0,
                      margin: const EdgeInsets.only(left:2, right: 2),
                      decoration: BoxDecoration(
                        color: (currentPage == i) ? widget.paginationActiveColor : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    )
                ],
              ),
            )
        )


      ],
    );
  }

  getActivePage(double width, double scrollOffset){
    return scrollOffset/width;
  }

  setNext(){
    if(currentOffset != (widget.width * (widget.content.length-1))){
      scrollController.animateTo(
        (currentOffset + widget.width),
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }

  }

  setPrevious(){
    if(currentOffset != 0){
      scrollController.animateTo(
        (currentOffset - widget.width),
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    }
  }

}

