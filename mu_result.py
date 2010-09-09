# mu_result.py - Fetches the result of Mumbai University students

# Usage: $ python mu_result.py <exam_month> <exam_year> <exam_id> <seat_no>
# Eg: $ python mu_result.py may 2010 1339 994

# For finding the result of multiple students:
# Usage: $ python mu_result.py <exam_month> <exam_year> <exam_id> <starting_seat_no>
# <ending_seat_no>
# Eg: $ python mu_result.py may 2010 1339 994 1000

# You can find out the exam id by looking at the link of the result page.

# Copyright (C) 2010 Gaurav Menghani <gaurav.menghani@gmail.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

import urllib
import urllib2
import sys

if len(sys.argv) < 5:
    print "Usage: $ python mu_result.py <exam_month> <exam_year> <exam_id> <seat_no>"
    print "or, "
    print "$ python mu_result.py <exam_month> <exam_year> <exam_id> <starting_seat_no>\
   <ending_seat_no>"
    sys.exit(1)

result_uri = "http://results.mu.ac.in/get_resultb.php"

exam_month = sys.argv[1]
exam_year = sys.argv[2]
exam_id = sys.argv[3]
seat_no = sys.argv[4]

if len(sys.argv) < 6:
    end_seat_no = seat_no
else:
    end_seat_no = sys.argv[5]

data = { 'exam_month' : exam_month, 
          'exam_year' : exam_year,
          'exam_id'   : exam_id,
          'seat_no'   : '' }
            
for i in range(int(seat_no), int(end_seat_no) + 1):
    data['seat_no'] = str(i)
    enc_data = urllib.urlencode(data)
    request = urllib2.Request("http://results.mu.ac.in/get_resultb.php", enc_data)
    response = urllib2.urlopen(request)
    response_str = response.read()
    
    start_i = response_str.find("<b>")
    end_i = response_str.find("</b>")
    if start_i == -1 or end_i == -1 or start_i + 3 >= end_i - 1:
        print i, ": Cannot find"
    else:
       print i, ":", response_str[start_i + 3 : end_i ]
