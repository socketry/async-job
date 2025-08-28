# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2025, by Samuel Williams.

def performance_log_rate
	File.open("performance.log", "r") do |file|
		start_time = nil
		end_time = nil
		count = 0
		
		file.each_line do |line|
			line = eval(line.strip)
			if line[:start_time]
				if start_time.nil? or start_time > line[:start_time]
					start_time = line[:start_time]
				end
			elsif line[:end_time]
				if end_time.nil? or end_time < line[:end_time]
					end_time = line[:end_time]
				end
				count += 1
			end
		end
		
		if start_time && end_time && count > 0
			rate = count / (end_time - start_time)
			puts "Processed #{count} jobs at #{rate.round(2)} jobs/sec"
		else
			puts "No jobs processed."
		end
	end
end
