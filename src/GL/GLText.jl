# Graphic text font implementation
# Vector definition of printable ASCII codes as 1D LAR models.
# Font design from [Geometric Programming for Computer-Aided Design](https://www.amazon.com/Geometric-Programming-Computer-Aided-Design/dp/0471899429?_encoding=UTF8&%2AVersion%2A=1&%2Aentries%2A=0), Wiley, 2003.
"""
	hpcs::Array


"""
hpcs = Tuple{Array{Float64,N} where N,Array{Array{Int64,1},1}}[([0.0, 0.0], [[1]]), ([1.75 1.75 2.0 2.0 1.5 1.5; 1.75 5.5 0.5 1.0 1.0 0.5], [[1, 2], [3, 4], [4, 5], [5, 6], [6, 3]]), ([1.0 2.0 2.0 2.0 1.5 1.5 2.0 3.0 3.0 3.0 2.5 2.5; 4.0 5.0 5.5 6.0 6.0 5.5 4.0 5.0 5.5 6.0 6.0 5.5], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 3], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 9]]), ([1.0 3.0 1.0 3.0 1.25 1.75 2.25 2.75; 2.5 2.5 3.5 3.5 1.75 4.0 1.75 4.0], [[1, 2], [3, 4], [5, 6], [7, 8]]), ([0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 2.0 2.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0 -0.5 6.5], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [13, 14]]), ([2.5 2.5 2.0 2.0 2.5 2.5 2.0 2.0 1.5 3.5; 0.0 0.5 0.5 0.0 5.5 6.0 6.0 5.5 5.5 11.5], [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 5], [9, 10]]), ([4.0 3.0 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 5.0 4.0 2.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14]]), ([1.0 2.0 2.0 2.0 1.5 1.5; 4.0 5.0 5.5 6.0 6.0 5.5], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 3]]), ([2.0 1.0 0.5 1.0 2.0; 0.0 1.0 3.0 5.0 6.0], [[1, 2], [2, 3], [3, 4], [4, 5]]), ([2.0 3.0 3.5 3.0 2.0; 0.0 1.0 3.0 5.0 6.0], [[1, 2], [2, 3], [3, 4], [4, 5]]), ([1.0 3.0 2.0 2.0 1.0 3.0 1.0 3.0; 3.0 3.0 2.0 4.0 2.0 4.0 4.0 2.0], [[1, 2], [3, 4], [5, 6], [7, 8]]), ([1.0 3.0 2.0 2.0; 3.0 3.0 2.0 4.0], [[1, 2], [3, 4]]), ([1.0 2.0 2.0 2.0 1.5 1.5; -1.0 0.0 0.5 1.0 1.0 0.5], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 3]]), ([1.0 3.0; 3.0 3.0], [[1, 2]]), ([2.0 2.0 1.5 1.5 2.0; 0.0 0.5 0.5 0.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5]]), ([1.0 3.0; 0.0 6.0], [[1, 2]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [4, 8]]), ([0.0 2.0 2.0 0.0 4.0; 4.0 6.0 0.0 0.0 0.0], [[1, 2], [2, 3], [4, 5]]), ([0.0 0.0 1.0 3.0 4.0 4.0 0.0 4.0; 4.0 5.0 6.0 6.0 5.0 4.0 0.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]]), ([0.0 4.0 2.0 4.0 4.0 3.0 1.0 0.0 0.0; 6.0 6.0 4.0 2.0 1.0 0.0 0.0 1.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]]), ([4.0 0.0 4.0 4.0; 1.0 1.0 6.0 0.0], [[1, 2], [2, 3], [3, 4]]), ([4.0 0.0 0.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0; 6.0 6.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10]]), ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0; 6.0 6.0 5.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11]]), ([0.0 0.0 4.0 0.0; 5.0 6.0 6.0 0.0], [[1, 2], [2, 3], [3, 4]]), ([1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 4.0 4.0 3.0 1.0 0.0 0.0; 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 4.0 5.0 6.0 6.0 5.0 4.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [6, 5], [5, 9], [9, 10], [10, 11], [11, 12], [12, 13], [13, 14], [14, 6]]), ([0.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 0.0 0.0 1.0 5.0 6.0 6.0 5.0 3.0 2.0 2.0 3.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11]]), ([2.0 2.0 1.5 1.5 2.0 2.0 1.5 1.5; 1.0 1.5 1.5 1.0 3.0 3.5 3.5 3.0], [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 5]]), ([2.0 2.0 1.5 1.5 1.0 2.0 2.0 2.0 1.5 1.5; 3.0 3.5 3.5 3.0 -0.5 0.5 1.0 1.5 1.5 1.0], [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 7]]), ([3.0 0.0 3.0; 6.0 3.0 0.0], [[1, 2], [2, 3]]), ([1.0 3.0 1.0 3.0; 2.5 2.5 3.5 3.5], [[1, 2], [3, 4]]), ([1.0 4.0 1.0; 6.0 3.0 0.0], [[1, 2], [2, 3]]), ([2.0 2.0 1.5 1.5 1.75 1.75 3.0 3.0 2.0 1.0 0.0 0.0; 0.0 0.5 0.5 0.0 1.0 2.75 4.0 5.0 6.0 6.0 5.0 4.0], [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12]]), ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 2.0 1.0 2.0 3.0 2.0; 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 1.0 2.0 3.0 2.0 1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12], [12, 13]]), ([0.0 0.0 1.0 3.0 4.0 4.0 0.0 4.0; 0.0 5.0 6.0 6.0 5.0 0.0 2.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [7, 8]]), ([0.0 0.0 3.0 4.0 4.0 3.0 4.0 4.0 3.0 0.0 0.0 3.0; 0.0 6.0 6.0 5.0 4.0 3.0 2.0 1.0 0.0 0.0 3.0 3.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [11, 12]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]]), ([0.0 0.0 3.0 4.0 4.0 3.0 0.0; 0.0 6.0 6.0 5.0 1.0 0.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([4.0 0.0 0.0 4.0 0.0 3.0; 0.0 0.0 6.0 6.0 3.0 3.0], [[1, 2], [2, 3], [3, 4], [5, 6]]), ([0.0 0.0 4.0 0.0 3.0; 0.0 6.0 6.0 3.0 3.0], [[1, 2], [2, 3], [4, 5]]), ([2.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 3.0 3.0 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10]]), ([0.0 0.0 4.0 4.0 0.0 4.0; 0.0 6.0 6.0 0.0 3.0 3.0], [[1, 2], [3, 4], [5, 6]]), ([2.0 2.0 1.0 3.0 1.0 3.0; 0.0 6.0 0.0 0.0 6.0 6.0], [[1, 2], [3, 4], [5, 6]]), ([0.0 1.0 2.0 3.0 3.0 2.0 4.0; 1.0 0.0 0.0 1.0 6.0 6.0 6.0], [[1, 2], [2, 3], [3, 4], [4, 5], [6, 7]]), ([4.0 0.0 4.0 0.0 0.0; 6.0 3.0 0.0 0.0 6.0], [[1, 2], [2, 3], [4, 5]]), ([4.0 0.0 0.0; 0.0 0.0 6.0], [[1, 2], [2, 3]]), ([0.0 0.0 2.0 4.0 4.0; 0.0 6.0 4.0 6.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5]]), ([0.0 0.0 4.0 4.0 4.0; 0.0 6.0 2.0 0.0 6.0], [[1, 2], [2, 3], [4, 5]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0 1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]]), ([0.0 0.0 3.0 4.0 4.0 3.0 0.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 4.0; 1.0 0.0 0.0 1.0 5.0 6.0 6.0 5.0 1.0 1.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [10, 11]]), ([0.0 0.0 3.0 4.0 4.0 3.0 0.0 3.0 4.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0 2.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [8, 9]]), ([0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9], [9, 10], [10, 11], [11, 12]]), ([2.0 2.0 0.0 4.0; 0.0 6.0 6.0 6.0], [[1, 2], [3, 4]]), ([0.0 0.0 1.0 3.0 4.0 4.0; 6.0 1.0 0.0 0.0 1.0 6.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]), ([0.0 2.0 4.0; 6.0 0.0 6.0], [[1, 2], [2, 3]]), ([0.0 0.0 1.0 2.0 3.0 4.0 4.0; 6.0 3.0 0.0 3.0 0.0 3.0 6.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([0.0 4.0 0.0 4.0; 0.0 6.0 6.0 0.0], [[1, 2], [3, 4]]), ([0.0 2.0 4.0 2.0 2.0; 6.0 2.0 6.0 2.0 0.0], [[1, 2], [2, 3], [4, 5]]), ([0.0 4.0 0.0 4.0; 6.0 6.0 0.0 0.0], [[1, 2], [2, 3], [3, 4]]), ([2.0 1.0 1.0 2.0; 0.0 0.0 6.0 6.0], [[1, 2], [2, 3], [3, 4]]), ([1.0 3.0; 6.0 0.0], [[1, 2]]), ([2.0 3.0 3.0 2.0; 0.0 0.0 6.0 6.0], [[1, 2], [2, 3], [3, 4]]), ([1.0 2.0 3.0; 5.0 6.0 5.0], [[1, 2], [2, 3]]), ([1.0 4.0; 0.0 0.0], [[1, 2]]), ([2.0 2.0 3.0 2.5 2.5 2.0; 4.5 5.0 6.0 4.0 4.5 4.0], [[1, 2], [2, 3], [4, 5], [5, 1], [1, 6], [6, 4]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 3.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 0.0 0.0 1.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10], [10, 11]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0 3.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10], [10, 11]]), ([4.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 0.0; 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0 1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]]), ([4.0 4.0 3.0 2.0 1.0 1.0 0.0 2.0; 3.0 4.0 5.0 5.0 4.0 0.0 1.0 1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [7, 8]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 3.0 1.0 0.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 0.0 -1.0 -1.0 0.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [1, 9], [9, 10], [10, 11], [11, 12]]), ([4.0 4.0 3.0 1.0 0.0 0.0 0.0 1.0; 0.0 2.0 3.0 3.0 2.0 0.0 5.0 5.0], [[1, 2], [2, 3], [3, 4], [4, 5], [6, 7], [7, 8]]), ([1.0 3.0 1.0 3.0 2.0 2.0 2.25 2.25 1.75 1.75; 0.0 0.0 3.0 3.0 0.0 3.0 3.75 4.25 4.25 3.75], [[1, 2], [3, 4], [5, 6], [7, 8], [8, 9], [9, 10], [10, 7]]), ([1.0 3.0 2.0 2.0 1.0 0.0 2.25 2.25 1.75 1.75; 3.0 3.0 3.0 0.0 -1.0 0.0 3.75 4.25 4.25 3.75], [[1, 2], [3, 4], [4, 5], [5, 6], [7, 8], [8, 9], [9, 10], [10, 7]]), ([0.0 1.0 1.0 0.0 4.0 2.0 1.0 3.0 4.0; 0.0 0.0 3.0 3.0 0.0 0.0 1.0 3.0 3.0], [[1, 2], [2, 3], [3, 4], [5, 6], [6, 7], [7, 8], [8, 9]]), ([2.0 2.0 1.0 1.0 3.0; 0.0 5.0 5.0 0.0 0.0], [[1, 2], [2, 3], [4, 5]]), ([4.0 4.0 2.0 2.0 2.0 0.0 0.0 0.0; 0.0 3.0 2.0 0.0 3.0 2.0 0.0 3.0], [[1, 2], [2, 3], [4, 5], [5, 6], [7, 8]]), ([3.0 3.0 1.0 1.0 1.0; 0.0 3.0 2.0 0.0 3.0], [[1, 2], [2, 3], [4, 5]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 9]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 0.0 0.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 3.0 -1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10]]), ([4.0 3.0 1.0 0.0 0.0 1.0 3.0 4.0 4.0 4.0; 1.0 0.0 0.0 1.0 2.0 3.0 3.0 2.0 3.0 -1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8], [8, 1], [9, 10]]), ([0.0 2.0 1.0 1.0 1.0 2.0 3.0 4.0; 0.0 0.0 0.0 3.0 2.0 3.0 3.0 2.0], [[1, 2], [3, 4], [5, 6], [6, 7], [7, 8]]), ([0.0 4.0 3.0 1.0 0.0 1.0 3.0 4.0; 0.0 0.0 1.0 1.0 2.0 3.0 3.0 2.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7], [7, 8]]), ([1.0 3.0 2.0 2.0 2.0 3.0; 0.0 0.0 0.0 5.0 4.0 4.0], [[1, 2], [3, 4], [5, 6]]), ([0.0 1.0 1.0 2.0 3.0 4.0 4.0; 3.0 3.0 1.0 0.0 0.0 1.0 3.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([0.0 1.0 3.0 4.0; 3.0 0.0 3.0 3.0], [[1, 2], [2, 3], [3, 4]]), ([0.0 0.0 1.0 2.0 3.0 4.0 4.0; 3.0 2.0 0.0 2.0 0.0 2.0 3.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([0.0 1.0 4.0 1.0 4.0; 3.0 3.0 0.0 0.0 3.0], [[1, 2], [2, 3], [4, 5]]), ([0.0 1.0 2.5 0.0 1.0 4.0; 3.0 3.0 1.5 0.0 0.0 3.0], [[1, 2], [2, 3], [4, 5], [5, 6]]), ([0.0 0.0 3.0 0.0 3.0 4.0; 2.0 3.0 3.0 0.0 0.0 1.0], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]]), ([2.5 2.0 2.0 1.5 2.0 2.0 2.5; 6.5 6.0 3.5 3.0 2.5 0.0 -0.5], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([2.0 2.0; 0.0 5.0], [[1, 2]]), ([1.5 2.0 2.0 2.5 2.0 2.0 1.5; 6.5 6.0 3.5 3.0 2.5 0.0 -0.5], [[1, 2], [2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]), ([1.0 1.75 2.75 3.5; 5.0 5.5 5.0 5.5], [[1, 2], [2, 3], [3, 4]])]


"""
ascii_LAR = DataStructures.OrderedDict{Int,LAR}()

	ascii2lar::{Int,LAR}

*Ordered dictionary* of printable ASCII codes as one-dimensional *LAR models* in 2D.

`Key` is the `integer` ASCII code between 32 and 126.
# Example
```
julia> ascii2lar[46]
([2.0 2.0 … 1.5 2.0; 0.0 0.5 … 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5]])

julia> ascii2lar[126]
([1.0 1.75 2.75 3.5; 5.0 5.5 5.0 5.5], Array{Int64,1}[[1, 2], [2, 3], [3, 4]])
```
"""
ascii2lar = DataStructures.OrderedDict(zip(32:126,hpcs))



# Attributes for `text` 2D graphics primitive.
# Reference to GKS ISO Graphics Standard (ISO/IEC 7942-4:1998)

global textalignment = "centre" #default value
global textangle = pi/4 #default value
global textwidth = 1.0 #default value
global textheight = 1.0 #default value
global textspacing = 0.25 #default value
global fontwidth = 4.0 #default value
global fontheight = 8.0 #default value
global fontspacing = 1.0 #default value


"""
	charpols(mystring::String)::Array{LAR,1}

Return the `array` of `LAR` models, for chars in `mystring`.
"""
function charpols(mystring)
    return [ascii2lar[code] for code in [Int(char) for char in mystring]]
end



"""
	charseq(mystring::String)::Array{Char,1}

# Example
```
julia> charseq("PLaSM")
5-element Array{Char,1}:
 'P'
 'L'
 'a'
 'S'
 'M'
```
"""
function charseq(mystring)
	return [char for char in mystring]
end


"""
	text(mystring::String)::LAR

Compute the one-dim *LAR model* drawing the contents of `mystring`

# Example
```
julia> model = text("PLaSM")
# output
([0.0 0.0 3.0 4.0 4.0 3.0 0.0 9.0 5.0 5.0 14.0 13.0 11.0 10.0
10.0 11.0 13.0 14.0 14.0 14.0 15.0 16.0 18.0 19.0 19.0 18.0 16.0 15.0 15.0 16.0 18.0
19.0 20.0 20.0 22.0 24.0 24.0; 0.0 6.0 6.0 5.0 3.0 2.0 2.0 0.0 0.0 6.0 1.0 0.0 0.0 1.0
2.0 3.0 3.0 2.0 0.0 3.0 1.0 0.0 0.0 1.0 2.0 3.0 3.0 4.0 5.0 6.0 6.0 5.0 0.0 6.0 4.0
6.0 0.0],
Array{Int64,1}[[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[8,9],[9,10],[11,12],[12,13],[13,14],
[14,15],[15,16],[16,17],[17,18],[18,11],[19,20],[21,22],[22,23],[23,24],[24,25],[25,26],
[26,27],[27,28],[28,29],[29,30],[30,31],[31,32],[33,34],[34,35],[35,36],[36,37]])

julia> VIEW([GLLar2gl(model...)])
```
"""
function text(mystring,flag=true)
	V,EV = comp([ struct2lar, Struct, Cat, distr,
			cons([ charpols, k(Lar_t(fontspacing+fontwidth,0)) ]),charseq ])(mystring)
	out = normalize3(V,flag),EV
	return out
end


"""
	GLText(string)::GLMesh

Transform a string into a mesh of lines.
To display as graphical text.
# Example
```
julia> text("Plasm")
([0.0 0.0 … 0.833333 0.833333; 0.0 0.25 … 0.0 0.125; 0.0 0.0 … 0.0 0.0], Array{Int64,1}[[1, 2], [2, 3], [3, 4], [4, 5], [5, 6]
, [6, 7], [8, 9], [9, 10], [11, 12], [13, 14]  …  [25, 26], [26, 27], [27, 28], [28, 29], [29, 30], [31, 32], [32, 33], [34, 3
5], [35, 36], [37, 38]])

julia> GLText("Plasm")
ViewerGLMesh(1, [1.0 0.0 0.0 0.0; 0.0 1.0 0.0 0.0; 0.0 0.0 1.0 0.0; 0.0 0.0 0.0 1.0], ViewerGLVertexArray(-1), ViewerGLVertexBuffer(-1, Float32[0.0, 0.25, 0.0, 0.0, 0.0, 0.0, 0.125, 0.25, 0.0, 0.0  …  0.0, 0.916667, 0.125, 0.0, 0.833333, 0.125, 0.0, 0.833333, 0.0, 0.0]), ViewerGLVertexBuffer(-1, Float32[]), ViewerGLVertexBuffer(-1, Float32[]))
```
"""
function GLText(string,color=COLORS[12])::GLMesh
	GLLines(text(string)...,color)
end


"""
	a2a(mat::Matrix)(models::Array{LAR,1})::Struct.body

Local function, service to `textWithAttributes` implementation.
"""
function a2a(mat)
	function a2a0(models)
		assembly = []
		for model in models
			push!( assembly, Struct([ mat,model ]) )
		end
		assembly
	end
	return a2a0
end


"""
	translate(c::Number)(lar::LAR)::LAR

Local function, service to `textWithAttributes` implementation.
"""
function translate(c)
	function translate0(lar)
		xs = lar[1][1,:]
		width = maximum(xs) - minimum(xs)
		apply(Lar_t(width/c,0))(lar)
	end
	return translate0
end


"""
	align(textalignment="centre"::String)(model::LAR)::LAR

Local function, service to `textWithAttributes` implementation.
"""
function align(textalignment="centre")
	function align1(model)
		if ( textalignment == "centre" ) out=translate(-2)(model)
		elseif ( textalignment == "right" ) out=translate(-1)(model)
		elseif ( textalignment == "left" ) out=model
		end
		return out
	end
end



"""
 	Cat(args)

Redefined locally, as service to `textWithAttributes` implementation.
```
julia> Cat([[1,2],[3,4],[],[5,6,7,8]])==collect(1:8)
true
```
"""
function Cat(args)
	return reduce( (x,y) -> append!(x,y), args; init=[] )
end


"""
	textWithAttributes(textalignment='centre', textangle=0,
		textwidth=1.0, textheight=2.0, textspacing=0.25)(strand::String)::LAR

Partial implementation of the GKS's graphics primitive `text`.

# Example

```
VIEW([
	GLLines(textWithAttributes("centre", pi/4)("PLaSM")...),
	GLAxis(Point3d(0,0,0),Point3d(1,1,1))
	])
```
VIEW([
	GLLines(textWithAttributes("left", pi/4)("PLaSM")...),
	GLAxis(Point3d(0,0,0),Point3d(1,1,1))
])
"""
function textWithAttributes(textalignment="centre", textangle=0,
							textwidth=1.0, textheight=2.0, textspacing=0.25)
	function textWithAttributes(strand)

		id = x->x
		mat = Lar_s(textwidth/fontwidth,textheight/fontheight)
		comp([
		   apply(Lar_r(textangle)),
		   align(textalignment),
		   struct2lar,
		   Struct,
		   Cat,
		   distr,
		   cons([ a2a(mat) ∘ charpols,
				k(Lar_t(textwidth+textspacing,0)) ]),
		   charseq ])(strand)
	end
end


"""
	embed(n::Int)(model::LAR)::LAR

Embed a `LAR` `model` of dimension ``d`` in a space ``R^{d+n}``.
The embedding is done by adding ``d`` zero coordinates to each vertex.

# Example

```
julia> square = cuboid([1,1])
([0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0], Array{Int64,1}[[1, 2, 3, 4]])

julia> embed(1)(square)
([0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0; 0.0 0.0 0.0 0.0], Array{Int64,1}[[1, 2, 3, 4]])
```
"""
function embed(n)
	function embed0( larmodel )
		return [larmodel[1]; zeros(n,size(larmodel[1],2))], larmodel[2]
	end
	return embed0
end


"""
	numbering(model::LARmodel)

Display a *wireframe* of `model` cells, of any dimension, with their *ordinal number*.
Different `colors` and size are used for the various dimensional cells.

# Examples

```
model = cuboidGrid([3,4,2], true);
VIEW(numbering()(model));

model = cuboidGrid([10,10], true);
meshes = numbering(1.5)(model);
VIEW(meshes)
```
"""
function numbering(sizeScaling=1.)
	function numbering0(model,color=COLORS[1],alpha=0.2)
		V,cells = model
		meshes = []
		if length(cells)>2
			#background = GLHulls(V, cells[3], color, alpha)
		end
		if size(V,1)==2
			V = embed(1)(model)[1]
		end
		wireframe = V,cells[2]
		ns = sizeScaling
		gcode = textWithAttributes("centre", 0, 0.1ns, 0.2ns, 0.025ns)
		push!(meshes,GLLines(wireframe[1],wireframe[2],color))

		colors = COLORS[3], COLORS[7], COLORS[5], COLORS[8]

		for (h,skel) in zip(1:length(cells),cells)
	 	  nums = []
		  for (k,cell) in zip(1:length(skel),skel)
				center = sum([V[:,v] for v in cell])/length(cell)
				code = embed(1)( gcode(string(k)) )
				scaling = (0.6+0.1h,0.6+0.1h,1)
				push!(nums, struct2lar( Struct([
					Lar_t(center...), Lar_s(scaling...), code ]) ))
		  end
		  for num in nums
				mesh = GLLines(num[1],num[2],colors[h])
				push!( meshes, mesh )
		  end
		end
		#if length(cells)>2 push!( meshes, background ) end
		return meshes
	end
	return numbering0
end


#function numbering1(Model,scaling=1.)
#	function numbering0(model,color=COLORS[1],alpha=0.2)
#		# dictionary of global unit chains
#		SkelDict = []
#		for (k,skel) in enumerate(Model[2])
#			push!(SkelDict, DataStructures.OrderedDict(zip(skel,1:length(skel))))
#		end
#		# dictionary of local unit chains
#		skeldict = []
#		for (k,skel) in enumerate(model[2])
#		  push!(skeldict, DataStructures.OrderedDict(zip(skel,1:length(skel))))
#    end
#		# dictionary of local unit chains with global keys
#		skelDict = []
#		for (k,skel) in enumerate(model[2])
#			vect = []
#			for key in collect(keys(skeldict[k]))
#				push!(vect, (key,SkelDict[k][key]))
#			end
#			push!(skelDict, DataStructures.OrderedDict(vect))
#		end
#		@show SkelDict; # dizionario globale (SD)
#		@show skeldict; # dizionario locale (sd)
#		@show skelDict; # dizionario locale con chiavi globali (sD)
#	end
#	return numbering0
#end

#"""
##	numbering(scaling=0.1)
##		(V::Points, copEV::ChainOp, copFE::ChainOp)::Hpc
#
#Produce the numbered `Hpc` of `planar_arrangement()` 2D output.
#Vertices in `V` are stored by row.
#
## Example
#
#```julia
#using LinearAlgebraicRepresentation
#using SparseArrays
#Lar = LinearAlgebraicRepresentation
#using ViewerGL; GL = ViewerGL
#
#V,EV = randomcuboids(10, 1.0);
#V = normalize(V,flag=true);
#W = convert(Points, V');
#cop_EV = coboundary_0(EV::Cells);
#cop_EW = convert(ChainOp, cop_EV);
#V, copEV, copFE = planar_arrangement(W, cop_EW);
#EV = cop2lar(copEV)
#FV = [collect(Set(Cat(EV[e] for e in SparseArrays.findnz(copFE[i,:])[1]))) for i=1:size(copFE,1)]
#VV = [[v] for v=1:size(V,1)]
#model = (convert(Points, V'), Cells[VV,EV,FV])
#meshes = numbering(.02)(model, COLORS[1], 0.1);
#VIEW(meshes);
#```
#"""
function numbering1(scaling=0.1)
function numbering0(model::Tuple{Points,ChainOp,ChainOp})
	(V, copEV, copFE) = model
	VV = [[k] for k=1:size(V,1)]
	EV = [SparseArrays.findnz(copEV[h,:])[1] for h=1:size(copEV,1)]
	FV = [collect(Set(Cat(EV[e] for e in SparseArrays.findnz(copFE[i,:])[1]))) for i=1:size(copFE,1)]
	#FV = convert(Array{Array{Int64,1},1}, FV)
	model = (convert(Points, V'), Cells[VV,EV,FV])
	return numbering(scaling)(model)
end
return numbering0
end


function cons(funs)
	return x -> [f(x) for f in funs]
end
function comp(funs)
	function compose(f,g)
	  return x -> f(g(x))
	end
	id = x->x
	return reduce(compose, funs; init=id)
end
function distr(args)
	list,element = args
	return [ [e,element] for e in list ]
end



"""
	k(Any)(x)

*Constant* functional of FL and PLaSM languages.

Gives a constant functional that always returns the actual parameter
when applied to another parameter.

#	Examples

```
julia> k(10)(100)
10

julia> k(sin)(cos)
sin
```
"""
function k(any::Any)
	x->any
end



"""
	apply(affineMatrix::Matrix)(larmodel::LAR)::LAR

Apply the `affineMatrix` parameter to the vertices of `larmodel`.

# Example

```
julia> square = LinearAlgebraicRepresentation.cuboid([1,1])
([0.0 0.0 1.0 1.0; 0.0 1.0 0.0 1.0], Array{Int64,1}[[1, 2, 3, 4]])

julia> apply(LinearAlgebraicRepresentation.t(1,2))(square)
([1.0 1.0 2.0 2.0; 2.0 3.0 2.0 3.0], Array{Int64,1}[[1, 2, 3, 4]])
```
"""
function apply(affineMatrix::Array{Float64,2})
	function apply0(larmodel)
		return apply( affineMatrix, larmodel )
	end
	return apply0
end



"""
	COMP(Funs)

Compose an Array of functions.
```
julia> COMP([sin,cos,tan])(pi/4)
0.5143952585235492

julia> COMP([sin,cos,tan])(pi/4) == (sin∘cos)(1)
true
```
"""
function COMP(Funs)
	function ∘(f,g)
		function h(x)
			return f(g(x))
		end
		return h
	end
	return reduce(∘,Funs)
end
