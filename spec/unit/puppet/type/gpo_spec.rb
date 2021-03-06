require 'spec_helper'

describe Puppet::Type.type(:gpo) do
    let(:valid_string_path) {
        'windowsupdate::autoupdatecfg::allowmuupdateservice'
    }

    let(:valid_scoped_string_path) {
        'User::WordWheel::CustomSearch::InternetExtensionName'
    }

    let(:valid_both_string_path) {
        'User::inetres::Advanced_DisableFlipAhead::Enabled'
    }

    let(:valid_hash_path) {
        'advancedfirewall::wf_firewallrules::firewallrules'
    }

    context 'when using namevar' do
        it 'should have namevars' do
            expect(described_class.key_attributes).to eq([:name, :scope, :admx_file, :policy_id, :setting_valuename])
        end

        it 'should accept a composite namevar with default scope' do
            res = described_class.new(:title => valid_string_path)
            expect(res[:scope]).to eq(:machine)
            expect(res[:admx_file]).to eq('windowsupdate')
            expect(res[:policy_id]).to eq('autoupdatecfg')
            expect(res[:setting_valuename]).to eq('allowmuupdateservice')
        end

        it 'should accept a composite namevar with scope' do
            res = described_class.new(:title => valid_scoped_string_path)
            expect(res[:scope]).to eq(:user)
            expect(res[:admx_file]).to eq('wordwheel')
            expect(res[:policy_id]).to eq('customsearch')
            expect(res[:setting_valuename]).to eq('internetextensionname')
        end
    end

    context 'when validating name' do
        it 'should accept a valid path' do
            res = described_class.new(:title => valid_string_path)
            expect(res[:name]).to eq(valid_string_path)
        end

        it 'should fail with an invalid path' do
            expect {
                described_class.new(
                    :title => 'foo',
                    :value => 'bar',
                )
            }.to raise_error(Puppet::Error, /Not a valid path: 'foo'/)
        end
    end

    context 'when validating scope' do
        it 'should accept a valid scope' do
            res = described_class.new(:title => valid_string_path)
            expect(res[:scope]).to eq(:machine)
        end

        it 'should accept a valid scope using both' do
            res = described_class.new(:title => valid_both_string_path)
            expect(res[:scope]).to eq(:user)
        end

        it 'should fail with an invalid scope' do
            expect {
                described_class.new(
                    :title => valid_string_path,
                    :scope => 'foo',
                )
            }.to raise_error(Puppet::Error, /Invalid value "foo"/)
        end
    end

    context 'when validating setting_valuename' do
        it 'should accept a valid setting_valuename' do
            res = described_class.new(:title => valid_string_path)
            expect(res[:setting_valuename]).to eq('allowmuupdateservice')
        end

        it 'should fail with an invalid path' do
            expect {
                described_class.new(
                    :title => 'foo::autoupdatecfg::allowmuupdateservice',
                    :value => 'bar'
                )
            }.to raise_error(Puppet::Error, /Not a valid path: 'foo::autoupdatecfg::allowmuupdateservice'/)
        end
    end

    context 'when validating ensure' do
        it 'should be ensurable' do
            expect(described_class.attrtype(:ensure)).to eq(:property)
        end

        it 'should be ensured to present by default' do
            res = described_class.new(:title => valid_string_path)
            expect(res[:ensure]).to eq(:present)
        end

        it 'should be ensurable to absent' do
            res = described_class.new(
                :title  => valid_string_path,
                :ensure => :absent
            )
            expect(res[:ensure]).to eq(:absent)
        end

        it 'should be ensurable to deleted' do
            res = described_class.new(
                :title  => valid_string_path,
                :ensure => :deleted
            )
            expect(res[:ensure]).to eq(:deleted)
        end
    end

    context 'when validating value' do
        it 'should have a value property' do
            expect(described_class.attrtype(:value)).to eq(:property)
        end

        context 'when expecting a string' do
            it 'should accept a string' do
                res = described_class.new(
                    :title => valid_string_path,
                    :value => 'foo',
                )
                expect(res[:value]).to eq('foo')
            end

            it 'should fail with a boolean' do
                expect {
                    described_class.new(
                        :title => valid_string_path,
                        :value => true,
                    )
                }.to raise_error(Puppet::Error, /Value should be a string, not 'true'/)
            end
        end

        context 'when expecting a hash' do
            it 'should accept a hash' do
                res = described_class.new(
                    :title => valid_hash_path,
                    :value => { 'foo' => 'bar' },
                )
                expect(res[:value]).to eq({'foo' => 'bar'})
            end

            it 'should fail with a string' do
                expect {
                    described_class.new(
                        :title => valid_hash_path,
                        :value => 'foo',
                    )
                }.to raise_error(Puppet::Error, /Value should be a hash, not 'foo'/)
            end
        end
    end
end
