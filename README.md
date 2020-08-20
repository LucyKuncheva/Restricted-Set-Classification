# Restricted-Set-Classification
MATLAB code for simultaneous classification of a set objects when there are label restrictions

### What is restricted set classification? 
[More can be found here](https://lucykuncheva.co.uk/other_research/full_class_set.html)

Have you ever wondered how a team filming a documentary about a group of wild animals recognise 
each individual animal in the group? The animals are so alike that it is nearly impossible to 
tell them apart! An automatic classifier will likely make a lot of mistakes. But if you try to 
recognise the animals from a single photo, you have extra information! There can only be one of 
each in the group. In other words, if your classifier returns two Georges, you know that it 
is wrong. Can we improve the accuracy by taking the extra information on board?

Given is a set of objects _S_, each coming from one of _c_ classes. Each object has 
been classified already, and the classifier returns estimates of the posterior 
probabilities _P_ ( object | class 1 ), ... _P_ ( object | class _c_ )  . 
The MATLAB code calculates a label for each individual object under the restriction that 
there are at most _k_(_i_) objects from class _i_.

### Code

  - `rsc.m`  The restricted set classification function. Four methods are implemented to create 
  a match between objects and labels: 
    - (1) The Hungarian algorithm,
	- (2) A greedy algorithm, 
	- (3) Sampling from the distribution of the posterior probabilities, and 
	- (4) The Naive algorithm where the classifier labels each point based on the posterior 
  probability and regardless of the restrictions.

  - `assignment_hungarian` A function that implement the Hungarian algorithm 
  (Written by Alex Melin, 30 June 2006). This function is used within `rsc.m`.
  
  - `TestRSC.m` A script that tests `rsc.m` on an example from the paper: 
  Kuncheva L. I., J. J. Rodríguez and A. S. Jackson, Restricted Set Classification: 
  Who is there?, Pattern Recognition, 63, 2017, 158–170. p. 161
  [[pdf here]](https://lucykuncheva.co.uk/papers/lkjrajpr17.pdf)

------------
