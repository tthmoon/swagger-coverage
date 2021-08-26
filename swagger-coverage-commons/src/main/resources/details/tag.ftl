<#import "operation.ftl" as operation />
<#import "../ui.ftl" as ui/>

<#macro list tags>
    <div class="accordion" id="tags-accordion">
        <#list tags as tag, tagCoverage>
            <div class="card">
                <div class="card-header">
                    <div class="row"
                         data-toggle="collapse"
                         data-target="#tag-${tag?index}"
                         aria-expanded="true"
                         aria-controls="collapseOne">
                        <div class="col-4">
                            <strong>${tag}<#if tagCoverage.tag.getDescription()??>: ${tagCoverage.tag.getDescription()}</#if></strong>
                        </div>
                        <div class="col-2">
                            ${tagCoverage.operations?size} ${i18["details.tag.operations"]}
                        </div>
                        <div class="col-2">
                            ${tagCoverage.callCounts} ${i18["details.operation.calls"]}
                        </div>
                        <div class="col-4">
                            <@ui.progress
                            full=tagCoverage.conditionCounter.all
                            current=tagCoverage.conditionCounter.covered
                            postfix=i18["details.conditionprogress.postfix"]
                            />
                        </div>
                    </div>
                </div>
                <div id="tag-${tag?index}" class="collapse" aria-labelledby="headingOne">
                    <div class="card-body">
                        <@ui.coverageBadget counter=tagCoverage.coverageCounter/>
                        <#list tagCoverage.operations as op>
                            <@operation.details
                            name=op
                            operationResult=operationMap[op]
                            target="tag-" + tag + "-" + op?counter
                            />
                        </#list>
                    </div>
                </div>
            </div>
        </#list>
    </div>
</#macro>