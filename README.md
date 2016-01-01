# qss-swirl
Swirl Lessons for the book manuscript, ``A First Course in Quantitative Social Science.''  See also the main repo, [qss](../../../qss), for other supplementary materials.  

If you are an instructor, you may also be interested in [Socratic Swirl](https://github.com/dimagor/socraticswirl), which can be used to monitor and analyze your students' progress in these swirl lessons with an easy-to-use [dashboard](https://github.com/dimagor/socraticswirlInstructor).

* Install the `swirl` package:
```
install.packages("swirl")
```

* Install the `qss-swirl` lessons:
```
library(swirl) # load the swirl package
install_course_github("kosukeimai", "qss-swirl")
```

* Start a `qss-swirl` lesson (after loading the `swirl` package):
```
swirl()
```

* Uninstall the `qss-swirl` lessons (after loading the `swirl` package):
```
uninstall_course("qss-swirl")
```

* Update the `qss-swirl` lessons:  
  1. Uninstall `qss-swirl` 
  2. Install `qss-swirl`
