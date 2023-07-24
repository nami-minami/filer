//
//  ContentView.swift
//  filer
//
//  Created by 南奈弥 on 2023/07/05.
//

import SwiftUI
 
struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(getFolder(URL(fileURLWithPath: "/System")), id: \.self) {
                    url in
                    ItemCell(url:url)
                }
            }
            .navigationTitle("フォルダ検索")
        }
    }
}
 
/// アイテムセル表示View
/// URLで指定された１アイテムを表示する
/// フォルダの場合はサブフォルダへのリンク、その他の場合はファイル名を表示
struct ItemCell: View {
    let url: URL
    var body: some View {
        HStack {
            if url.hasDirectoryPath {
                /// フォルダ
                NavigationLink(destination: SubFolder(url: url)) {
                    Image(systemName: "folder")
                    Text(url.lastPathComponent + "/")
                }
            } else {
                /// ファイル
                Image(systemName: "doc.text")
                Text(url.lastPathComponent)
            }
        }
    }
}
 
/// サブフォルダ表示View
struct SubFolder: View {
    let url: URL
    var body: some View {
        List {
            ForEach(getFolder(url), id: \.self) { url in
                ItemCell(url:url)
            }
        }
    }
}
 
/// フォルダ取得
/// - Parameter url: 情報を取得するフォルダのURL
/// - Returns: 指定されたフォルダに含まれるアイテムのURLリストを返す
func getFolder(_ url: URL) -> [URL] {
    do {
        /// フォルダのURLからふくまれるURLを取得
        var fileAndFolderURLs = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
 
        /// ファイル名でソート
        fileAndFolderURLs.sort(by: {$0.lastPathComponent < $1.lastPathComponent})
        
        return fileAndFolderURLs
    } catch {
        print(error.localizedDescription)
        return []
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



