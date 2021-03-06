# coding: utf-8
require "thor"
require 'pdf_forms'
require 'yaml'
require 'colorize'
require 'open3'


module Limarka

  class Configuracao < Thor

    method_option :output_dir, :aliases => '-o', :desc => 'Diretório onde será salvo a exportação', :default => '.'
    method_option :input_dir, :aliases => '-i', :desc => 'Diretório onde será executado a ferramenta', :default => '.'
    desc "exporta", "Exporta configuração para YAML. Ler configuracao.pdf e salva em configuracao.yaml no diretório indicado"
    def exporta
      configuracao_pdf  = "configuracao.pdf"
      configuracao_yaml = "configuracao.yaml"
      Dir.chdir(options[:input_dir]) do
        raise IOError, "Arquivo não encontrado: #{options[:input_dir]}/" + configuracao_pdf unless File.exist? (configuracao_pdf)
        pdf = PdfForms::Pdf.new configuracao_pdf, (PdfForms.new 'pdftk'), utf8_fields: true
        pdfconf = Limarka::Pdfconf.new(pdf: pdf)

        # exporta sem validação
        h = pdfconf.exporta(false)

        target_file = options[:output_dir]+'/'+configuracao_yaml
        puts "Sobrescrevendo #{target_file}".green if File.exist?(target_file)
        Limarka::Trabalho.save_yaml(h, target_file)
      end
    end


    method_option :pdf_antigo, :aliases => "-p", :required => true
    desc "upgrade", "Após atualização de versão, atualiza os valores do novo arquivo configuracao.pdf a partir do antigo (que precisa ser especificado)"
    def upgrade
      puts "Ainda falta implementar".red
      #t = Limarka::Trabalho.new
      #configuracao = t.ler_configuracao(:configuracao_yaml => true)

    end

  end
end


