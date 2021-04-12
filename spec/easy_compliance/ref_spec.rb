require 'spec_helper'

describe EasyCompliance::Ref do
  before { EasyCompliance.app_name = 'MyApp' }

  specify '#for_record returns a string representing a record' do
    record = double(class: Object, id: 42)
    expect(EasyCompliance::Ref.for_record(record)).to eq 'MyApp#Object#42'
  end

  specify '#for returns a string based on given class and id' do
    expect(EasyCompliance::Ref.for(record_class: 'Foo', record_id: 23))
      .to eq 'MyApp#Foo#23'
  end

  describe '#look_up' do
    # stub some things so ActiveSupport/Record is not a hard dependency
    class MyCompliantRecord
      def self.find_by(id:)
        id == '42' ? :ok : nil
      end
    end

    before do
      allow_any_instance_of(String).to receive(:constantize) do |str|
        str == 'MyCompliantRecord' ? MyCompliantRecord : raise(NameError, str)
      end
    end

    it 'converts a ref back into a record' do
      expect(EasyCompliance::Ref.look_up('MyApp#MyCompliantRecord#42')).to eq :ok
    end

    it 'returns nil if the record no longer exists' do
      expect(EasyCompliance::Ref.look_up('MyApp#MyCompliantRecord#43')).to eq nil
    end

    it 'raises if the ref is from another app' do
      expect { EasyCompliance::Ref.look_up('OtherApp#MyCompliantRecord#42') }
        .to raise_error(EasyCompliance::Ref::Error)
    end

    it 'raises if the ref is for an unknown record class' do
      expect { EasyCompliance::Ref.look_up('MyApp#CeciNestPasUneRecord#42') }
        .to raise_error(EasyCompliance::Ref::Error)
    end
  end
end
