require 'spec_helper'

describe WPScan::Finders::TimthumbVersion::BadRequest do
  subject(:finder) { described_class.new(target) }
  let(:target)     { WPScan::Timthumb.new(url) }
  let(:url)        { 'http://ex.lo/timthumb.php' }
  let(:fixtures)   { File.join(FINDERS_FIXTURES, 'timthumb_version', 'bad_request') }

  describe '#aggressive' do
    before { stub_request(:get, url).to_return(body: File.read(File.join(fixtures, file))) }
    after  { expect(finder.aggressive).to eql @expected }

    context 'when no version' do
      let(:file) { 'no_version.php' }

      it 'returns nil' do
        @expected = nil
      end
    end

    context 'when a version' do
      let(:file) { '2.8.14.php' }

      it 'returns the expected version' do
        @expected = WPScan::Version.new(
          '2.8.14',
          confidence: 90,
          found_by: 'Bad Request (Aggressive Detection)',
          interesting_entries: [
            "#{url}, TimThumb version : 2.8.14"
          ]
        )
      end
    end
  end
end
