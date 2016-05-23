1. Copy all the files to a folder, lets say name of this folder is "Assignment_6_DSB150030"

2. Shift+Right Click in the folder and "Open command prompt here"!
Alternatively, you can use cd command.

3. Set path of R in current directory in command prompt by using link of your r bin. ex- 
C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>Path C:\Program Files\R\R-3.2.3\bin

4. Level 1 run using following command as required the command args are <k>, <input file>, <output file>. ex- 
C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>Rscript --vanilla DSB150030_Part1.R 5 test_data.txt outputLevel1.txt

5. Level 2 run using following command as required the commands args are <k>,<initial_seed> , <input tweets>, <output file>
C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>Rscript --vanilla DSB150030_Part2.R 25 InitialSeeds.txt Tweets.json outputLevel2.txt

6. Level 3 Bonus is done in Java. So, set path of java in command prompt using similar command.
C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>Path C:\Program Files\Java\jdk1.7.0_79\bin

7. Compile using following line, to create a class file. (Included in the folder.)
C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>javac kmeans.java

8. Run using following line.
C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>java kmeans image3.jpg 3
convergence

C:\Users\Dharmam\Desktop\Assignment_6_DSB150030>java kmeans image3.jpg 5
convergence

9. Results are kept in the clusteredimages folder and input images are image3, image4 and image5.(Included in the folder.)