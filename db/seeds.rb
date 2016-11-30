Skill.find_or_create_by(name: 'Customer Service', promoted: true)
Skill.find_or_create_by(name: 'Computer Experience', promoted: true)
Skill.find_or_create_by(name: 'Use of Office Machinery (i.e. fax, copier )', promoted: true)
Skill.find_or_create_by(name: 'Clerical Duties', promoted: true)
Skill.find_or_create_by(name: 'Foreign Languages', promoted: true)
Skill.find_or_create_by(name: 'Previous Library Experience', promoted: true)
Skill.find_or_create_by(name: 'Mathematics and Numeracy', promoted: true)
Skill.find_or_create_by(name: 'Creative', promoted: true)
Skill.find_or_create_by(name: 'Social Media', promoted: true)
Skill.find_or_create_by(name: 'Communication', promoted: true)

['No preference', 'Art', 'Architecture', 'Chemistry', 'Engineering and Physical Sciences Library',
 'Hornbake: Special Collections/University Archives', 'Hornbake: Library Media Services', 'McKeldin',
 'MS Performing Arts Library'].each { |name| Library.find_or_create_by(name: name) }
