
module Chef::Zero::DataStores
  describe FilesystemStore do
    let(:filesystem_store) {FilesystemStore.new(File.expand_path(File.join(File.dirname(__FILE__), "../example_files")))}
    subject {fielsystem_store}

    describe '#get' do
      subject {filesystem_store.get(['dir','child'])}
      it { should == {'a' => 1}}
    end

    describe '#list' do
      subject {filesystem_store.list(['dir'].sort)}
      it 'children can be seen' do
        should == ['child', 'child2'].sort
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
