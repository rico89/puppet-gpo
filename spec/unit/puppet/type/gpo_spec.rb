require 'spec_helper'

describe Puppet::Type.type(:gpo) do
    context 'when validating attributes' do
        it 'should have path as namevar' do
            expect(described_class.key_attributes).to eq([:path])
        end

        it 'should have a value property' do
            expect(described_class.attrtype(:value)).to eq(:property)
        end
    end
end
