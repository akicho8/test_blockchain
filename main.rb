require "bundler/inline"

gemfile do
  gem "org_tp"
end

require "digest"

class Blockchain
  attr_accessor :chain
  attr_accessor :current_transactions
  attr_accessor :node_ident

  def initialize
    @chain = []
    @current_transactions = []
    @nodes = []
    @node_ident = object_id
  end

  def block_add(proof, previous_hash = nil)
    block = {
      index: chain.size.next,
      timestamp: Time.now.to_i,
      transactions: current_transactions,
      proof: proof,
      previous_hash: previous_hash || hash_value(chain.last),
    }
    self.current_transactions = []
    chain << block
    block
  end

  def transaction_add(sender, recipient, amount)
    current_transactions << {
      sender: sender,       # 送信者
      recipient: recipient, # 受信者
      amount: amount,       # 量
    }

    chain.last[:index].next
  end

  def hash_value(v)
    Digest::SHA256.hexdigest(v.to_s)
  end

  # 0000 を探すのは時間がかかるため 00 程度にしておく
  def proof_valid?(last_proof, proof)
    hash_value("#{last_proof}#{proof}").start_with?("00")
  end

  def register_node(address)
    parsed_url = URI::parse(address)
    @nodes.add("#{parsed_url.host}:#{parsed_url.port}")
  end

  def proof_of_work(last_proof)
    proof = 0
    loop do
      if proof_valid?(last_proof, proof)
        break
      end
      proof += 1
    end
    proof
  end

  def mine
    proof = proof_of_work(chain.last[:proof])
    transaction_add("0", node_ident, 1)
    block = block_add(proof)
    {message: "発掘"}.merge(block)
  end

  # chain.size がもっとも長いもの残す
  def conflicts_resolve
    max = chain.size
    nodes.each do |node|
      # length = response[:length]
      # chain = response[:chain]
      #
      #   if length > max && chain_valid?(chain)
      #     max = length
      #     new_chain = chain
      #   end
      # end
    end

    # if new_chain
    #   @chain = new_chain
    #   return true
    # end
    #
    # return false
  end

  # chain の配列すべてをチェックする
  def chain_valid?(chain)
    last_block = chain[0]
    current_index = 1

    while current_index < chain.size
      block = chain[current_index]

      if block[:previous_hash] != hash_value(last_block)
        return false
      end

      if !valid_proof(last_block[:proof], block[:proof])
        return false
      end

      last_block = block
      current_index += 1
    end

    true
  end
end

instance = Blockchain.new # => #<Blockchain:0x00007fc24a1ccd20 @chain=[], @current_transactions=[], @nodes=[], @node_ident=70236221892240>
instance.block_add(100, 1)      # 初期値
tp instance.mine  # => {:message=>"発掘", :index=>2, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>226, :previous_hash=>"1e12149b6bc46c0f54f16766d51f8882d7f690dacb90ee546cee6ce7ceae6485"}
20.times { instance.mine }
tp instance.chain # => [{:index=>1, :timestamp=>1517472647, :transactions=>[], :proof=>100, :previous_hash=>1}, {:index=>2, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>226, :previous_hash=>"1e12149b6bc46c0f54f16766d51f8882d7f690dacb90ee546cee6ce7ceae6485"}, {:index=>3, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>346, :previous_hash=>"e4b68f248e4572a82f9c89f97eadae28415e62c0cbee5c42bf806a1593f8b724"}, {:index=>4, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>57, :previous_hash=>"56d74b13be48950506a538955bb59821b7f035c6882f357f6771affe6b578e13"}, {:index=>5, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>289, :previous_hash=>"7367a22389e8ac87e3d92e0143c68da235f401409ad69b21a68f94cd6b15b181"}, {:index=>6, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>175, :previous_hash=>"dbe09abb8bc0b393d1d3e0023f31c6b5c8f0103d1683a15d97bb3bac348a1dfc"}, {:index=>7, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>27, :previous_hash=>"3711e9267d90d356937881411f22f7d0d191e6681e1b40707fbf75a3030f5832"}, {:index=>8, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>26, :previous_hash=>"f075f6324d216bb31174f2a26d0f7d66bdc95497508ee88d7259159c8055e213"}, {:index=>9, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>50, :previous_hash=>"b2dfb5f37655f7a9187a3a1a246cb159f527fd23795510afb2d19be13e61c04f"}, {:index=>10, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>329, :previous_hash=>"6254e87f16d507aa0deadb50c201c9c975e8035173d97472c51891967fef7ecd"}, {:index=>11, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>555, :previous_hash=>"1873141b6e95f1ecf29e791001879c1650583aad449242ca229ab8c14b8fb7b0"}, {:index=>12, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>85, :previous_hash=>"48d8fff4dadd3603a540b567bc8f78dffc39f4a39f79fbb2dcc08718079c35fb"}, {:index=>13, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>36, :previous_hash=>"7a4b48d7debcf0aac3436ba4f56527e36249eac1014bb090974327e4d081a2f1"}, {:index=>14, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>27, :previous_hash=>"8de6163c1d93289e4c5d237ea82a414dfbb10895e1f31b2fb353ce10efdae339"}, {:index=>15, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>26, :previous_hash=>"0bf76bd7fd17c3c39ef598f3e4f5d059ab92ab581a08b48f9ba1f674d4cae40f"}, {:index=>16, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>50, :previous_hash=>"2acd971fb5ab9e031e9d8ccf608d00af438572a096e7f40dcf86f35696c1e704"}, {:index=>17, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>329, :previous_hash=>"e4f61f6d11caba27082c0248e99143ef645cfef9c4f7b0de57927c503a2c2acd"}, {:index=>18, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>555, :previous_hash=>"9077c8b4dfbd7e23edba86f4191931de1e265f6be358aa3e5284e2b0d8b4e789"}, {:index=>19, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>85, :previous_hash=>"31b96fc975422cfeda09ee382cf4d030a1dc37940ccb554641c785abc7eceb16"}, {:index=>20, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>36, :previous_hash=>"fbf8f1eb01930ca7e25c1f1fe17b4d2af9991d72e972d04c980ca2321d11d1f0"}, {:index=>21, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>27, :previous_hash=>"921ad31ae527450346cb96b60b6dccc4b6dcf93a9b8d162abab4d1c2213c7ec7"}, {:index=>22, :timestamp=>1517472647, :transactions=>[{:sender=>"0", :recipient=>70236221892240, :amount=>1}], :proof=>26, :previous_hash=>"278d0bab555bc94c1bef1ebde06f274635a14e8fc396b93909dee8e306e340c2"}]
# >> |---------------+------------------------------------------------------------------|
# >> |       message | 発掘                                                             |
# >> |         index | 2                                                                |
# >> |     timestamp | 1517472647                                                       |
# >> |  transactions | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}]         |
# >> |         proof | 226                                                              |
# >> | previous_hash | 1e12149b6bc46c0f54f16766d51f8882d7f690dacb90ee546cee6ce7ceae6485 |
# >> |---------------+------------------------------------------------------------------|
# >> |-------+------------+----------------------------------------------------------+-------+------------------------------------------------------------------|
# >> | index | timestamp  | transactions                                             | proof | previous_hash                                                    |
# >> |-------+------------+----------------------------------------------------------+-------+------------------------------------------------------------------|
# >> |     1 | 1517472647 | []                                                       |   100 |                                                                1 |
# >> |     2 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   226 | 1e12149b6bc46c0f54f16766d51f8882d7f690dacb90ee546cee6ce7ceae6485 |
# >> |     3 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   346 | e4b68f248e4572a82f9c89f97eadae28415e62c0cbee5c42bf806a1593f8b724 |
# >> |     4 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    57 | 56d74b13be48950506a538955bb59821b7f035c6882f357f6771affe6b578e13 |
# >> |     5 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   289 | 7367a22389e8ac87e3d92e0143c68da235f401409ad69b21a68f94cd6b15b181 |
# >> |     6 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   175 | dbe09abb8bc0b393d1d3e0023f31c6b5c8f0103d1683a15d97bb3bac348a1dfc |
# >> |     7 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    27 | 3711e9267d90d356937881411f22f7d0d191e6681e1b40707fbf75a3030f5832 |
# >> |     8 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    26 | f075f6324d216bb31174f2a26d0f7d66bdc95497508ee88d7259159c8055e213 |
# >> |     9 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    50 | b2dfb5f37655f7a9187a3a1a246cb159f527fd23795510afb2d19be13e61c04f |
# >> |    10 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   329 | 6254e87f16d507aa0deadb50c201c9c975e8035173d97472c51891967fef7ecd |
# >> |    11 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   555 | 1873141b6e95f1ecf29e791001879c1650583aad449242ca229ab8c14b8fb7b0 |
# >> |    12 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    85 | 48d8fff4dadd3603a540b567bc8f78dffc39f4a39f79fbb2dcc08718079c35fb |
# >> |    13 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    36 | 7a4b48d7debcf0aac3436ba4f56527e36249eac1014bb090974327e4d081a2f1 |
# >> |    14 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    27 | 8de6163c1d93289e4c5d237ea82a414dfbb10895e1f31b2fb353ce10efdae339 |
# >> |    15 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    26 | 0bf76bd7fd17c3c39ef598f3e4f5d059ab92ab581a08b48f9ba1f674d4cae40f |
# >> |    16 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    50 | 2acd971fb5ab9e031e9d8ccf608d00af438572a096e7f40dcf86f35696c1e704 |
# >> |    17 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   329 | e4f61f6d11caba27082c0248e99143ef645cfef9c4f7b0de57927c503a2c2acd |
# >> |    18 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |   555 | 9077c8b4dfbd7e23edba86f4191931de1e265f6be358aa3e5284e2b0d8b4e789 |
# >> |    19 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    85 | 31b96fc975422cfeda09ee382cf4d030a1dc37940ccb554641c785abc7eceb16 |
# >> |    20 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    36 | fbf8f1eb01930ca7e25c1f1fe17b4d2af9991d72e972d04c980ca2321d11d1f0 |
# >> |    21 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    27 | 921ad31ae527450346cb96b60b6dccc4b6dcf93a9b8d162abab4d1c2213c7ec7 |
# >> |    22 | 1517472647 | [{:sender=>"0", :recipient=>70236221892240, :amount=>1}] |    26 | 278d0bab555bc94c1bef1ebde06f274635a14e8fc396b93909dee8e306e340c2 |
# >> |-------+------------+----------------------------------------------------------+-------+------------------------------------------------------------------|
