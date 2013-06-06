module Chef::Zero::DataStores
  describe FallbackStore do
    let(:fallback_store) {FallbackStore.new(read_write_store, read_only_store1, read_only_store2)}
    subject {fallback_store}
    let(:read_write_store) {mock(:read_write_store)}
    let(:read_only_store1) {mock(:read_only_store1)}
    let(:read_only_store2) {mock(:read_only_store2)}

    describe '#clear' do
      it 'delegates to the read write store' do
        read_write_store.should_receive(:clear)
        subject.clear
      end
    end

    describe '#create_dir' do
      it 'delegates to the read write store' do
        read_write_store.should_receive(:create_dir)
        subject.create_dir
      end
    end

    describe '#create' do
      it 'delegates to the read write store' do
        read_write_store.should_receive(:create)
        subject.create
      end
    end

    describe '#set' do
      it 'delegates to the read write store' do
        read_write_store.should_receive(:set)
        subject.set
      end
    end

    describe '#delete' do
      it 'delegates to the read write store' do
        read_write_store.should_receive(:delete)
        subject.delete
      end
    end

    describe '#delete_dir' do
      it 'delegates to the read write store' do
        read_write_store.should_receive(:delete_dir)
        subject.delete_dir
      end
    end

    describe '#get' do
      subject {fallback_store.get(['path'])}
      before do
        read_write_store.stub(:get) {read_write_value}
        read_only_store1.stub(:get) {read_only_value}
      end
      let(:read_write_value) {nil}
      let(:read_only_value) {nil}
      context 'when a read only store has a value' do
        let(:read_only_value) {'value2'}
        context 'when the read write store does not match' do
          it('returns the first read only store\'s value') {should == read_only_value}
        end

        context 'when the read write store matches' do
          let(:read_write_value) {'value'}
          it('returns the read write store\'s value') {should == read_write_value}
        end
      end

      context 'when no read only store has a value' do
        context 'when the read write store does not match' do
          before do
            read_only_store2.should_receive(:get) {nil}
          end
          it('returns nil') {should == nil}
        end

        context 'when the read write store matches' do
          let(:read_write_value) {'value'}
          it('returns the read write store\'s value') {should == read_write_value}
        end
      end
    end

    describe '#list' do
      subject {fallback_store.list(['path'])}
      before do
        read_write_store.stub(:list) {['b','z']}
        read_only_store1.stub(:list) {['b']}
        read_only_store2.stub(:list) {['a']}
      end
      it 'should combine sort and remove duplicates' do
        should == ['a', 'b', 'z']
      end
    end
  end
end
