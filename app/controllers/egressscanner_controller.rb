class EgressscannerController < ApplicationController

  def index
    @bar_length = get_ports.length - 1
    if params[:check] == 'true'
      egress_report
    else
      egress_check(get_ports)
    end
    respond_to do |format|
      format.js
    end
  end

  def get_ports
    ports = (0..1024).to_a
    ports << [8000,8181,8443,8888]
    ports << (8080..8089).to_a
    ports = ports.flatten.sort

    blocked_ports = [0,1,7,9,11,13,15,17,19,20,21,22,23,25,37,42,43,53,77,79,87,95,101,102,103,104,109,110,111,113,115,117,119,123,135,139,143,179,389,465,512,513,514,515,526,530,531,532,540,556,563,587,601,636,993,995]
    blocked_ports.each do |blocked_port|
      ports.delete(blocked_port)
    end
    return ports
  end

  def egress_check(ports)
    @egress_code = "var openPorts = [];\n"
    @egress_code += "var egress_checks = \"\";\n"

    for port in ports
      @egress_code += "egress_checks += \"<script type='text/javascript' src='http://blackhole.exploitable.me:#{port}/egressscanner?check=true&port=#{port}'></script>\";\n"
     end
      @egress_code += "document.write(egress_checks);\n"
  end

  def egress_report
    @egress_code = %Q{function portStatus () {openPorts.push(#{params[:port]});}}
  end

end


