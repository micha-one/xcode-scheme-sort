import Foundation

func main() throws {
    guard CommandLine.arguments.count >= 2 else {
        print("Error: Required argument missing!\n")
        printUsage()
        return
    }
    guard CommandLine.arguments[1].hasSuffix(".xcodeproj") else {
        print("Error: First argument must be a path to a *.xcodeproj file!\n")
        printUsage()
        return
    }

    var userName = NSUserName()
    if CommandLine.arguments.count >= 3 {
        userName = CommandLine.arguments[2]
    }

    try sortSchemes(inFileAtPath: "\(CommandLine.arguments[1])/xcuserdata/\(userName).xcuserdatad/xcschemes/xcschememanagement.plist")
}

func sortSchemes(inFileAtPath path: String) throws {
    print("Sorting schemes in \(path)")
    var plist = try loadPlist(path: path)

    var schemeUserState = plist["SchemeUserState"] as! [String: Any]
    
    schemeUserState.keys.sorted().enumerated().forEach { (index: Int, schemeName: String) in
        var scheme = schemeUserState[schemeName] as! [String: Any]
        scheme["orderHint"] = 1000 + index
        schemeUserState[schemeName] = scheme
    }
    plist["SchemeUserState"] = schemeUserState

    savePlist(dictionary: plist, toPath: path)
    
    print("\(schemeUserState.keys.count) Schemes sorted.")
}

func loadPlist(path: String) throws -> [String: Any] {
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)

    let plist = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)

    return plist as! [String: Any]
}

func savePlist(dictionary: [String: Any], toPath path: String) {
    let outputStream = OutputStream(toFileAtPath: path, append: false)!
    outputStream.open()
    PropertyListSerialization.writePropertyList(dictionary, to: outputStream, format: .xml, options: 0, error: nil)
    outputStream.close()
}

func printUsage() {
    print("Usage: \(CommandLine.arguments[0]) <path to *.xcodeproj file> [user name]")
}

do {
    try main()
} catch {
    print(error)
}
