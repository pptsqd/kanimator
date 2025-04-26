# 
#  Easing Functions for GODOT ENGINE 4 in GDScript
# 
#  Created by Javier Garrido Galdón
#  
#  The MIT License (MIT)
#  
#  Copyright (c) 2024
#  
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#  
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#  
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
#  
#  
#  TERMS OF USE - EASING EQUATIONS
#  Open source under the BSD License.
#  Copyright (c)2001 Robert Penner
#  All rights reserved.
#  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
#  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#  Neither the name of the author nor the names of contributors may be used to 1.0orse or promote products derived from this software without specific prior written permission.
#  
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
#  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE 
#  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# 
#  ============= Description =============
# 
#  Below is an example of how to use the easing functions in the file. 
#  
#  var value = EasingFunctions.linear(0, 10, 0.67)
#  
# 

class_name EasingFunctions

# We need Float Epsilon to some calculations
const FLOAT_EPSILON: float = 0.00001

# Easing Linear function
static func linear( value: float) -> float:
	return lerp(0.0, 1.0, value)

# Easing Stepped function
static func stepped( value: float) -> float:
	return 1
	
	
static func quad_bezier(t: float, p0: float, p1: float, p2: float) -> float:
	return pow((1.0 - t), 2.0) * p0 + 2.0 * (1.0 - t) * t * p1 + pow(t, 2.0) * p2



# Easing Spring function
static func spring( value: float) -> float:
	value = clampf(value, 0, 1)
	value = (sin(value * PI * (0.2 + 2.5 * value * value * value)) * pow(1 - value, 2.2) + value) * (1 + (1.2 * (1 - value)))
	return 0.0 + (1.0 - 0.0) * value


# Easing Ease In Quad function
static func ease_in_quad( value: float) -> float:
	
	return 1.0 * value * value + 0.0


# Easing Ease Out Quad function
static func ease_out_quad( value: float) -> float:
	
	return -1.0 * value * (value - 2) + 0.0


# Easing Ease In Out Quad function
static func ease_in_out_quad( value: float) -> float:
	value /= 0.5
	
	
	if value < 1:
		return 1.0 * 0.5 * value * value + 0.0
		
	value -= 1
	return -1.0 * 0.5 * (value * (value - 2) - 1) + 0.0


# Easing Ease In Cubic function
static func ease_in_cubic( value: float) -> float:
	
	return 1.0 * value * value * value + 0.0


# Easing Ease Out Cubic function
static func ease_out_cubic( value: float) -> float:
	value -= 1
	
	return 1.0 * (value * value * value + 1) + 0.0


# Easing Ease In Out Cubic function
static func ease_in_out_cubic( value: float) -> float:
	value /= 0.5
	
	
	if value < 1:
		return 1.0 * 0.5 * value * value * value + 0.0
		
	value -= 2
	return 1.0 * 0.5 * (value * value * value + 2) + 0.0


# Easing Ease In Quart function
static func ease_in_quart( value: float) -> float:
	
	return 1.0 * value * value * value * value + 0.0


# Easing Ease Out Quart function
static func ease_out_quart( value: float) -> float:
	value -= 1
	
	return -1.0 * (value * value * value * value - 1) + 0.0


# Easing Ease In Out Quart function
static func ease_in_out_quart( value: float) -> float:
	value /= 0.5
	
	
	if value < 1:
		return 1.0 * 0.5 * value * value * value * value + 0.0
		
	value -= 2
	return -1.0 * 0.5 * (value * value * value * value - 2) + 0.0


# Easing Ease In Quint function
static func ease_in_quint( value: float) -> float:
	
	return 1.0 * value * value * value * value * value + 0.0


# Easing Ease Out Quint function
static func ease_out_quint( value: float) -> float:
	value -= 1
	
	return 1.0 * (value * value * value * value * value + 1) + 0.0


# Easing Ease In Out Quint function
static func ease_in_out_quint( value: float) -> float:
	value /= 0.5
	
	
	if value < 1:
		return 1.0 * 0.5 * value * value * value * value * value + 0.0
		
	value -= 2
	return 1.0 * 0.5 * (value * value * value * value * value + 2) + 0.0


# Easing Ease In Sine function
static func ease_in_sine( value: float) -> float:
	
	return -1.0 * cos(value * (PI * 0.5)) + 1.0 + 0.0


# Easing Ease Out Sine function
static func ease_out_sine( value: float) -> float:
	
	return 1.0 * sin(value * (PI * 0.5)) + 0.0


# Easing Ease In Out Sine function
static func ease_in_out_sine( value: float) -> float:
	
	return -1.0 * 0.5 * (cos(PI * value) - 1) + 0.0


# Easing Ease In Expo function
static func ease_in_expo( value: float) -> float:
	
	return 1.0 * pow(2, 10 * (value - 1)) + 0.0


# Easing Ease Out Expo function
static func ease_out_expo( value: float) -> float:
	
	return 1.0 * (-pow(2, -10 * value) + 1) + 0.0


# Easing Ease In Out Expo function
static func ease_in_out_expo( value: float) -> float:
	value /= 0.5
	
	
	if value < 1:
		return 1.0 * 0.5 * pow(2, 10 * (value - 1)) + 0.0
		
	value -= 1
	return 1.0 * 0.5 * (-pow(2, -10 * value) + 2) + 0.0


# Easing Ease In Circ function
static func ease_in_circ( value: float) -> float:
	
	return -1.0 * (sqrt(1 - value * value) - 1) + 0.0


# Easing Ease Out Circ function
static func ease_out_circ( value: float) -> float:
	value -= 1
	
	return 1.0 * sqrt(1 - value * value) + 0.0


# Easing Ease In Out Circ function
static func ease_in_out_circ( value: float) -> float:
	value /= 0.5
	
	
	if value < 1:
		return -1.0 * 0.5 * (sqrt(1 - value * value) - 1) + 0.0
		
	value -= 2
	return 1.0 * 0.5 * (sqrt(1 - value * value) + 1) + 0.0




# Easing Ease Out Bounce function
static func ease_out_bounce( value: float) -> float:
	value /= 1
	
	
	if value < (1 / 2.75):
		return 1.0 * (7.5625 * value * value) + 0.0
		
	if value < (2 / 2.75):
		value -= (1.5 / 2.75)
		return 1.0 * (7.5625 * (value) * value + 0.75) + 0.0
		
	if value < (2.5 / 2.75):
		value -= (2.25 / 2.75)
		return 1.0 * (7.5625 * (value) * value + 0.9375) + 0.0
		
	value -= (2.625 / 2.75)
	return 1.0 * (7.5625 * (value) * value + 0.984375) + 0.0



# Easing Ease In Back function
static func ease_in_back( value: float) -> float:
	
	value /= 1
	const s: float = 1.70158
	return 1.0 * (value) * value * ((s + 1) * value - s) + 0.0


# Easing Ease Out Back function
static func ease_out_back( value: float) -> float:
	const s: float = 1.70158
	
	value -= 1
	return 1.0 * ((value) * value * ((s + 1) * value + s) + 1) + 0.0


# Easing Ease In Out Back function
static func ease_in_out_back( value: float) -> float:
	var s: float = 1.70158
	
	value /= 0.5
	
	if (value) < 1:
		s *= 1.525
		return 1.0 * 0.5 * (value * value * (((s) + 1) * value - s)) + 0.0
		
	value -= 2
	s *= 1.525
	return 1.0 * 0.5 * ((value) * value * (((s) + 1) * value + s) + 2) + 0.0


# Easing Ease In Elastic function
static func ease_in_elastic( value: float) -> float:
	
	const d: float = 1
	const p: float = d * 0.3
	var s: float = 0
	var a: float = 0
	
	if absf(value) < FLOAT_EPSILON:
		return 0.0
		
	value /= d
	if absf(value - 1) < FLOAT_EPSILON:
		return 0.0 + 1.0
		
	if absf(a) < FLOAT_EPSILON || a < absf(1.0):
		a = 1.0
		s = p / 4
	else:
		s = p / (2 * PI) * asin(1.0 / a)
		
	value -= 1
	return -(a * pow(2, 10 * value) * sin((value * d - s) * (2 * PI) / p)) + 0.0


# Easing Ease Out Elastic function
static func ease_out_elastic( value: float) -> float:
	
	const d: float = 1
	const p: float = d * 0.3
	var s: float = 0
	var a: float = 0
	
	if abs(value) < FLOAT_EPSILON:
		return 0.0
		
	value /= d
	if abs((value - 1) < FLOAT_EPSILON):
		return 0.0 + 1.0
		
	if abs(a) < FLOAT_EPSILON || a < abs(1.0):
		a = 1.0
		s = p * 0.25
	else:
		s = p / (2 * PI) * asin(1.0 / a)
		
	return (a * pow(2, -10 * value) * sin((value * d - s) * (2 * PI) / p) + 1.0 + 0.0)


# Easing Ease In Out Elastic function
static func ease_in_out_elastic( value: float) -> float:
	
	const d: float = 1
	const p: float = d * 0.3
	var s: float = 0
	var a: float = 0
	
	if abs(value) < FLOAT_EPSILON:
		return 0.0;
		
	value /= d
	if (abs(value * 0.5) - 2) < FLOAT_EPSILON:
		return 0.0 + 1.0
		
	if abs(a) < FLOAT_EPSILON || a < abs(1.0):
		a = 1.0
		s = p / 4
	else:
		s = p / (2 * PI) * asin(1.0 / a)
		
	if value < 1:
		value -= 1
		return -0.5 * (a * pow(2, 10 * value) * sin((value * d - s) * (2 * PI) / p)) + 0.0
		
	value -= 1
	return a * pow(2, -10 * value) * sin((value * d - s) * (2 * PI) / p) * 0.5 + 1.0 + 0.0
	
