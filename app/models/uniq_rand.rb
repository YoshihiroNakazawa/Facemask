##
## 重複なし乱数の生成(Fisher-Yates改)
##
#
# 長さNで(0 .. N-1)の重複しない乱数の繰り返し
#
# UniqRand.new(size) : 長さsizeで乱数を初期化
# UniqRand.getNext : 乱数を取り出す
#
class UniqRand
    private
    # メモから数値を取り出す
    def readMemo(i)
        # 指定されたインデックスの更新状況を確認
        if @flags[i] != @mark # 未更新なら
            # インデックス値でメモを更新
            @values[i] = i
            # 更新済みフラグをマーク
            @flags[i] = @mark
        end
        # 更新済みであればメモから返す
        @values[i]
    end

    public
    def initialize(size)
        @size = size    # 数列の長さ
        @index = 0      # 乱数の取り出し位置
        @mark = false   # 更新済みマーカー
        @flags = Array.new(@size, !@mark)   # 更新済みフラグ
        @values = Array.new(@size)          # 数列メモ
    end

    # 数値を取り出す
    def getNext
        # 1周終わったら数列を初期化
        if @index >= @size
            # マーカーを更新
            @mark = !@mark
            # 取り出し位置を巻き戻す
            @index = 0
        end
        # シャッフル先をランダムに決める
        ptr = rand(@index .. @size - 1)

        # 取り出し位置とシャッフル先について、メモから数値を取り出す
        # ※メモを更新するので先に両方共取り出しておくこと
        dst = readMemo(ptr)
        src = readMemo(@index)

        # 取り出した値を入れ替える
        @values[ptr] = src
        @values[@index] = dst

        # 取り出し位置を更新
        @index += 1

        # 取り出した値を返す
        return dst
    end
end
