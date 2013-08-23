
module Chef::Zero::DataStores
  describe FilesystemStore do
    let(:filesystem_store) {FilesystemStore.new(File.expand_path(File.join(File.dirname(__FILE__), "../example_files")))}
    subject {filesystem_store}

    describe '#get' do
      let(:path) { ['dir','child'] }
      subject { filesystem_store.get(path) }
      it { should == {'a' => 1}}
      context 'when the file does not exist' do
        let(:path) { ['missing'] }
        it { expect{subject}.to raise_error(ChefZero::DataStore::DataNotFoundError) {|error| expect(error.path).to eq(path) } }
      end
    end

    describe '#list' do
      let(:path) { ['dir'] }
      subject {filesystem_store.list(path).sort}
      it 'children can be seen' do
        should == ['child', 'child2'].sort
      end
      context 'when the directory does not exist' do
        let(:path) { ['missing'] }
        it { expect{subject}.to raise_error(ChefZero::DataStore::DataNotFoundError) {|error| expect(error.path).to eq(path) } }
      end
    end

    describe '#exists?' do
      subject {filesystem_store.exists?(path)}
      context 'the file exists' do
        let(:path) {['file']}
        it 'exists? returns true' do
          should == true
        end
      end
      context 'the file does not exists' do
        let(:path) {['nonexistant_file']}
        it 'exists? returns false' do
          should == false
        end
      end
    end

    describe '#exists_dir?' do
      subject {filesystem_store.exists_dir?(path)}
      context 'the dir exists' do
        let(:path) {['dir']}
        it 'exists? returns true' do
          should == true
        end
      end
      context 'the dir does not exists' do
        let(:path) {['nonexistant_dir']}
        it 'exists? returns false' do
          should == false
        end
      end
    end

  end
end
