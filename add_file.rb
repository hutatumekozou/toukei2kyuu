# encoding: utf-8
require 'xcodeproj'
project_path = '統計2級.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first
group = project.main_group.find_subpath('Sources/Managers', true)
group.set_source_tree('<group>')
file_ref = group.new_reference('Sources/Managers/HistoryManager.swift')
target.add_file_references([file_ref])
project.save
