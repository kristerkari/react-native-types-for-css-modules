puts "reading newest Git tag..."
newest_tag = `git describe --tags $(git rev-list --tags --max-count=1)`
puts newest_tag
if $?.exitstatus != 0
  raise "no git tag, exiting..."
end

current_version = Gem::Version.new(newest_tag.sub!(/^v/, ""))
puts "getting list of @types/react-native versions..."
versions = eval(`npm show @types/react-native versions`)

newer_versions = versions.select do |v|
  Gem::Version.new(v) > current_version
end

if !newer_versions.empty?
  puts "newer versions:"
  puts newer_versions
else
  puts "no new versions."
end

newer_versions.each do |v|
  puts "removing existing @types/react native..."
  system("rm -rf node_modules")

  puts "installing @types/react-native@#{v}..."
  system("npm install @types/react-native@#{v} --no-save")

  puts "checking for type file names..."

  expected_type_files = ["LaunchScreen.d.ts", "globals.d.ts", "index.d.ts", "legacy-properties.d.ts", "BatchedBridge.d.ts", "Devtools.d.ts", "Codegen.d.ts"]
  installed_type_files = Dir["./node_modules/@types/react-native/*.d.ts"].map { |f| File.basename(f) }

  if expected_type_files.uniq.sort != installed_type_files.uniq.sort
    raise "type files included in @types/react-native has changed. This script needs to be updated.\nNew files are:\n#{installed_type_files}"
  else
    puts "installed @types/react-native type files:"
    puts installed_type_files
  end

  puts "replacing current types with @types/react-native@#{v}..."

  system("rm LaunchScreen.d.ts")
  system("cp node_modules/@types/react-native/LaunchScreen.d.ts LaunchScreen.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/LaunchScreen.d.ts > LaunchScreen.d.ts")

  system("rm globals.d.ts")
  system("cp node_modules/@types/react-native/globals.d.ts globals.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/globals.d.ts > globals.d.ts")

  system("rm index.d.ts")
  system("cp node_modules/@types/react-native/index.d.ts index.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/index.d.ts > index.d.ts")

  system("rm legacy-properties.d.ts")
  system("cp node_modules/@types/react-native/legacy-properties.d.ts legacy-properties.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/legacy-properties.d.ts > legacy-properties.d.ts")

  system("rm BatchedBridge.d.ts")
  system("cp node_modules/@types/react-native/BatchedBridge.d.ts BatchedBridge.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/BatchedBridge.d.ts > BatchedBridge.d.ts")

  system("rm Devtools.d.ts")
  system("cp node_modules/@types/react-native/Devtools.d.ts Devtools.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/Devtools.d.ts > Devtools.d.ts")

  system("rm Codegen.d.ts")
  system("cp node_modules/@types/react-native/Codegen.d.ts Codegen.d.ts")
  system("tr -d '\r' < node_modules/@types/react-native/Codegen.d.ts > Codegen.d.ts")

  puts "adding className prop to @types/react-native@#{v}..."
  system("ruby write_classname.rb")

  puts "bump package.json version..."
  system("npm --no-git-tag-version version #{v}")

  puts "committing v#{v}..."
  system("git add index.d.ts globals.d.ts legacy-properties.d.ts BatchedBridge.d.ts Devtools.d.ts Codegen.d.ts package.json")
  system("git commit -m v#{v}")

  puts "tagging v#{v}..."
  system("git tag -a v#{v} -m 'v#{v}'")
  puts "--------------------------------"
end

