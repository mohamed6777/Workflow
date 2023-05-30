configfile:"config.yaml"
rule all:
	input:
		expand("variants_filtered/{dataset}.fil.vcf", dataset=config["datasets"])
rule filtered_variants:
    input:
        "variants/{dataset}.vcf"
    output:
        "variants_filtered/{dataset}.fil.vcf"
    shell:
       "snpEff -Xmx8g -v hg19kg {input} | "
       "SnpSift annotate -exists -v gnomad gnomad/gnomad.exomes.r2.0.2.sites.vcf.gz /dev/stdin | "
       "SnpSift filter -n ' (exists ID) & !( ID = 'gnomad' )' /dev/stdin > {output}"

       rule sigprofiler:
    input:"vcf/{dataset}.vcf"
    output: "results/output/{dataset}_SBS96.pdf"
    run:
        import tempfile
	f = tempfile.TemporaryDirectory(dir = "/fast/projects/hyperpanel/work/Mohamed_pipeline")
	import shutil
	temp = "tmp_file"
	shutil.move(f.name,temp)
	
        shell("cp {input} tmp_file/{wildcards.dataset}.vcf")
	#src_path = r"vcf/test_example_2.vcf"
	#dst_path = r"tmp_file/test_example_2.vcf"
	#shutil.copy(src_path, dst_path)

	from SigProfilerMatrixGenerator.scripts import SigProfilerMatrixGeneratorFunc as matGen 
        matrices = matGen.SigProfilerMatrixGeneratorFunc('test','GRCh37','tmp_file',plot=True)
        import shutil
        shell("cp tmp_file/output/plots/SBS_96_plots_test.pdf {output} ")
        #src_path = r"tmp_file/output/plots/SBS_96_plots_test.pdf"
        #dst_path = r"git/test_example_2_SBS96.pdf"

        #shutil.copy(src_path, dst_path)
	dir_path = r"/fast/projects/hyperpanel/work/Mohamed_pipeline/tmp_file"
	shutil.rmtree(dir_path)