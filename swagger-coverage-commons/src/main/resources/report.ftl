<#ftl output_format="HTML">

<#global i18=messages>
<#global operationMap=data.flatOperations>

<#-- @ftlvariable ftlvariable name="data" type="com.github.viclovsky.swagger.coverage.model.SwaggerCoverageResults" -->
<#import "ui.ftl" as ui/>
<#import "sections/summary.ftl" as summary />
<#import "sections/generation.ftl" as generation />
<#import "details/operation.ftl" as operations />
<#import "details/condition.ftl" as condition />
<#import "details/tag.ftl" as tag />

<head>
    <meta charset="utf-8">
    <title>Swagger Coverage</title>
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
            integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
            integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css"
          integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <script src="https://kit.fontawesome.com/0b83173bdb.js" crossorigin="anonymous"></script>
    <style>
        .title {
            margin-top: 60px;
        }

        .progress {
            position: relative;
        }

        .progress span {
            position: absolute;
            display: block;
            width: 100%;
            color: black;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
    <div class="container">
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <a class="navbar-brand" href="#">${data.info.getTitle()!} ${data.info.getVersion()!}</a>
            <ul class="navbar-nav mr-auto">
                <li class="nav-item">
                    <a class="nav-link" href="#summary-section">${i18["menu.summary"]}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#details-section">${i18["menu.operations"]}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#tag-section">${i18["menu.tags"]}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#condition-section">${i18["menu.condition"]}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#system-section">${i18["menu.generation"]}</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<main role="main" class="container">
    <div class="container">
        <section id="summary-section">
            <div class="row">
                <div class="col-12">
                    <h2 class="title" id="summary">${i18["menu.summary"]}</h2>
                </div>
            </div>
            <@summary.operations operationCoveredMap=data.coverageOperationMap />
            <@summary.calls data=data />
            <@summary.tags tagsDetail=data.tagCoverageMap tagCounter=data.tagCounter />
            <@summary.conditions counter=data.conditionCounter />
        </section>

        <section id="details-section">
            <div class="row">
                <div class="col-12">
                    <h2 class="title" id="details">${i18["menu.operations"]}</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <ul class="nav nav-pills nav-fill" id="detail-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="condition-tab" data-toggle="tab" href="#condition" role="tab"
                               aria-controls="condition" aria-selected="true">
                                ${i18["operations.all"]}: ${data.operations?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="full-tab" data-toggle="tab" href="#full" role="tab"
                               aria-controls="full" aria-selected="true">
                                ${i18["operations.full"]}: ${data.coverageOperationMap.full?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="party-tab" data-toggle="tab" href="#party" role="tab"
                               aria-controls="party" aria-selected="true">
                                ${i18["operations.partial"]}: ${data.coverageOperationMap.party?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="empty-tab" data-toggle="tab" href="#empty" role="tab"
                               aria-controls="empty" aria-selected="true">
                                ${i18["operations.empty"]}: ${data.coverageOperationMap.empty?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="zero-tab" data-toggle="tab" href="#zero" role="tab"
                               aria-controls="zero" aria-selected="true">
                                ${i18["operations.no_call"]}: ${data.zeroCall?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="missed-tab" data-toggle="tab" href="#missed" role="tab"
                               aria-controls="missed" aria-selected="false">
                                ${i18["operations.missed"]}: ${data.missed?size}
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="deprecated-tab" data-toggle="tab" href="#deprecated" role="tab"
                               aria-controls="deprecated" aria-selected="false">
                                ${i18["operations.deprecated"]}: ${data.deprecated?size}
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <br/>
            <div class="row">
                <div class="col-12">
                    <div class="tab-content" id="details-content">
                        <div class="tab-pane fade show active" id="condition" role="tabpanel" aria-labelledby="condition-tab">
                            <@condition.list
                                coverage=data.coverageOperationMap.full + data.coverageOperationMap.party + data.coverageOperationMap.empty
                                prefix="condition"/>
                        </div>
                        <div class="tab-pane fade" id="full" role="tabpanel" aria-labelledby="full-tab">
                            <@condition.list coverage=data.coverageOperationMap.full prefix="full"/>
                        </div>
                        <div class="tab-pane fade" id="party" role="tabpanel" aria-labelledby="party-tab">
                            <@condition.list coverage=data.coverageOperationMap.party prefix="party"/>
                        </div>
                        <div class="tab-pane fade" id="empty" role="tabpanel" aria-labelledby="empty-tab">
                            <@condition.list coverage=data.coverageOperationMap.empty prefix="empty"/>
                        </div>
                        <div class="tab-pane fade" id="zero" role="tabpanel" aria-labelledby="zero-tab">
                            <@condition.list coverage=data.zeroCall prefix="zero"/>
                        </div>
                        <div class="tab-pane fade" id="missed" role="tabpanel" aria-labelledby="missed-tab">
                            <@operations.list coverage=data.missed prefix="missed"/>
                        </div>
                        <div class="tab-pane fade" id="deprecated" role="tabpanel" aria-labelledby="deprecated-tab">
                            <@operations.list coverage=data.deprecated prefix="deprecated"/>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section id="tag-section">
            <div class="row">
                <div class="col-12">
                    <h2 class="title" id="tags">${i18["menu.tags"]}</h2>
                </div>
            </div>
            <@tag.list tags=data.tagCoverageMap/>
        </section>

        <section id="condition-section">
            <div class="row">
                <div class="col-12">
                    <h2 class="title" id="conditions">${i18["menu.condition"]}</h2>
                </div>
            </div>
            <div class="row">
                <div class="accordion col-12" id="conditions-by-type-accordion">
                    <#list data.conditionStatisticsMap as key, value>
                        <div class="card">
                            <div class="card-header">
                                <div class="row"
                                     data-toggle="collapse"
                                     data-target="#conditions-by-type-${key?index}"
                                     aria-expanded="true"
                                     aria-controls="collapseOne">
                                    <div class="col-8">
                                        <#assign nameKey = "predicate.${key}.name">
                                        <#assign descriptionKey = "predicate.${key}.description">
                                        <p><strong>${i18[nameKey]!nameKey}</strong></p>
                                        <small>${i18[descriptionKey]!descriptionKey}</small>
                                    </div>
                                    <div class="col-4">
                                        <@ui.progress
                                            full=value.allCount
                                            current=value.coveredCount
                                            postfix=i18["details.conditionprogress.postfix"]
                                        />
                                    </div>
                                </div>
                            </div>
                            <div id="conditions-by-type-${key?index}" class="collapse" aria-labelledby="headingOne">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-12">
                                            <ul class="nav nav-pills nav-fill" id="condition-tabs-${key?index}" role="tablist">
                                                <li class="nav-item">
                                                    <a class="nav-link active" id="tab-condition-covered-${key?index}" data-toggle="tab" href="#condition-covered-${key?index}" role="tab"
                                                       aria-controls="condition-covered-${key?index}" aria-selected="true">
                                                        ${i18["summary.conditions.covered"]}: ${value.coveredOperation?size}
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" id="tab-condition-uncovered-${key?index}" data-toggle="tab" href="#condition-uncovered-${key?index}" role="tab"
                                                       aria-controls="condition-uncovered-${key?index}" aria-selected="true">
                                                        ${i18["summary.conditions.uncovered"]}: ${value.uncoveredOperation?size}
                                                    </a>
                                                </li>
                                            </ul>
                                        </div>
                                    </div>
                                    <br>
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="tab-content" id="details-content-${key?index}">
                                                <div class="tab-pane fade show active" id="condition-covered-${key?index}" role="tabpanel" aria-labelledby="tab-condition-covered-${key?index}">
                                                    <table class="table table-sm">
                                                        <thead>
                                                        <tr>
                                                            <th scope="col">${i18["details.condition.operation"]}</th>
                                                            <th scope="col">${i18["details.condition.conditionname"]}e</th>
                                                            <th scope="col">${i18["details.condition.details"]}</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <#list value.coveredOperation as conditionItem>
                                                            <tr class="table-success">
                                                                <td>
                                                                    <span>
                                                                        <i class="fas fa-check"></i>
                                                                    </span>
                                                                    &nbsp;${conditionItem.operation}
                                                                </td>
                                                                <td>${conditionItem.condition.name}</td>
                                                                <td>${conditionItem.condition.reason?no_esc}</td>
                                                            </tr>
                                                        </#list>
                                                        </tbody>
                                                    </table>
                                                </div>
                                                <div class="tab-pane fade" id="condition-uncovered-${key?index}" role="tabpanel" aria-labelledby="tab-condition-uncovered-${key?index}">
                                                    <table class="table table-sm">
                                                        <thead>
                                                        <tr>
                                                            <th scope="col">${i18["details.condition.operation"]}</th>
                                                            <th scope="col">${i18["details.condition.conditionname"]}e</th>
                                                            <th scope="col">${i18["details.condition.details"]}</th>
                                                        </tr>
                                                        </thead>
                                                        <tbody>
                                                        <#list value.uncoveredOperation as conditionItem>
                                                            <tr class="table-danger">
                                                                <td>
                                                                    <span>
                                                                        <i class="fas fa-bug"></i>
                                                                    </span>
                                                                    &nbsp;${conditionItem.operation}
                                                                </td>
                                                                <td>${conditionItem.condition.name}</td>
                                                                <td>${conditionItem.condition.reason?no_esc}</td>
                                                            </tr>
                                                        </#list>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </#list>
                </div>
            </div>
        </section>

        <section id="system-section">
            <div class="row">
                <div class="col-12">
                    <h2 class="title" id="system">${i18["menu.generation"]}</h2>
                </div>
            </div>
            <@generation.data statistic=data.generationStatistics/>
            <div class="row">
                <div class="col-12">
                    <h4>${i18["generation.configuration"]}</h4>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <div class="col-sm">
                        <div class="alert alert-secondary" role="alert">
                            <pre>${data.prettyConfiguration} </pre>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <footer class="page-footer font-small mdb-color lighten-3 pt-4">
            <div class="footer-copyright text-center py-3"></div>
        </footer>

    </div>
</main>

</body>
