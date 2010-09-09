#!/usr/bin/env ruby

# mu_result.rb - Fetches the result of Mumbai University students

# Usage: $ ruby mu_result.rb <exam_month> <exam_year> <exam_id> <seat_no>
# Eg: $ ruby mu_result.rb may 2010 1339 994

# For finding the result of multiple students:
# Usage: $ ruby mu_result.rb <exam_month> <exam_year> <exam_id> <starting_seat_no>
# <ending_seat_no>
# Eg: $ ruby mu_result.rb may 2010 1339 994 1000

# You can find out the exam id by looking at the link of the result page.

# Dependencies: 

# rubygems
# libcurl-devel (required to gem install curb)
# curb - gem install curb

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

require 'rubygems'
require 'curb'

#Result page uri change as appropriate
result_uri = "http://results.mu.ac.in/get_resultb.php"

curlobj = Curl::Easy.new(result_uri)


exam_month = ''
exam_year = ARGV[1]
exam_id = ARGV[2]
seat_no = ARGV[3]
end_seat_no = ((ARGV[4].nil?) ? seat_no : ARGV[4]).to_i


if exam_month.nil? || exam_year.nil? || exam_id.nil? || seat_no.nil?
  puts "Usage: $ ruby mu_result.rb <exam_month> <exam_year> <exam_id> <seat_no>"
  puts "or, "
  puts "$ ruby mu_result.rb <exam_month> <exam_year> <exam_id> <starting_seat_no>\
 <ending_seat_no>"
  Process.exit(1)
end

i = seat_no.to_i
while i <= end_seat_no
  seat_no = i.to_s
  pf_exam_id = Curl::PostField.content('exam_id', exam_id)
  pf_exam_year = Curl::PostField.content('exam_year', exam_year)
  pf_exam_month = Curl::PostField.content('exam_month', exam_month)
  pf_seat_no = Curl::PostField.content('seat_no', seat_no)

  curlobj.http_post(pf_exam_id, pf_exam_year, pf_exam_month, pf_seat_no)

  # Result is enclosed between the last pair of b tags.
  # Might need to change this if they change the format of the page
  start_ind = curlobj.body_str.index("<b>")
  end_ind = curlobj.body_str.index("</b>")
  
  if start_ind.nil? || end_ind.nil? || start_ind + 3 >= end_ind - 1
    print "#{seat_no}: Could not find\n" 
  else
    start_ind = start_ind + 3
    end_ind = end_ind - 1
    print "#{seat_no}: ", curlobj.body_str[start_ind..end_ind], "\n"
  end
  i = i + 1
end
