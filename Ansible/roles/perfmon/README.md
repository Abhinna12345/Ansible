Role Name
=========

perfmon

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.
<table>
<tr>
<th>Argument</th>
<th>Description</th>
</tr>
<tr>
<td>appDir</td>
<td>The top level directory that contains your app. If this option is used then
it assumed your scripts are in</td>
</tr>
<tr>
<td>baseUrl</td>
<td>By default, all modules are located relative to this path. If baseUrl is not
explicitly set, then all modules are loaded relative to the directory that holds
the build file. If appDir is set, then baseUrl should be specified as relative
to the appDir.</td>
</tr>
<tr>
<td>dir</td>
<td>The directory path to save the output. If not specified, then the path will
default to be a directory called "build" as a sibling to the build file. All
relative paths are relative to the build file.</td>
</tr>
<tr>
<td>modules</td>
<td>List the modules that will be optimized. All their immediate and deep
dependencies will be included in the module's file when the build is done. If
that module or any of its dependencies includes i18n bundles, only the root
bundles will be included unless the locale: section is set above.</td>
</tr>
</table>
### Example of Counters
-----------------------
<table>
    <tr><th>Name & Threshold</th><th>Sample</th><th>Summary</th></tr>
    <tr><td nowrap>\LogicalDisk(_Total)\Avg. Disk sec/Read > 25ms</td>	<td>15 Mins</td>	<td>Avg. Disk sec/Read is the average time, in seconds, of a read of data to the disk. This analysis determines if any of the physical disks are responding slowly</td></tr>
<tr><td nowrap>\LogicalDisk(C:)\Avg. Disk sec/Read > 25ms</td>	<td>15 Mins</td>	<td>Avg. Disk sec/Read is the average time, in seconds, of a read of data to C:. This analysis determines if any of the physical disks are responding slowly on C:.</td></tr>
<tr><td nowrap>\LogicalDisk(E:)\Avg. Disk sec/Read > 15ms</td>	<td>15 Mins</td>	<td>Avg. Disk sec/Read is the average time, in seconds, of a read of data to E:. This analysis determines if any of the physical disks are responding slowly on E:.</td></tr>
<tr><td nowrap>\LogicalDisk(_Total)\Avg. Disk sec/Write > 25ms</td>	<td>15 Mins</td>	<td>Avg. Disk sec/Write is the average time, in seconds, of a write of data to the disk. This analysis determines if any of the physical disks are responding slowly</td></tr>
<tr><td nowrap>\LogicalDisk(_Total)\Disk Transfers/sec > 0.1</td>	<td>15 Mins</td>	<td>Disk Transfers/sec is the rate of read and write operations on the disk</td></tr>
<tr><td nowrap>\Memory\Available MBytes < 5000</td>	<td>15 Mins</td>	<td>Available MBytes is the amount of physical memory available to processes running on the computer, in Megabytes</td></tr>
<tr><td nowrap>\Memory\Free System Page Table Entries > 0.9</td>	<td>15 Mins</td>	<td>Free System Page Table Entries is the number of page table entries not currently in used by the system. This analysis determines if the system is running out of free system page table entries (PTEs) by checking if there is less than 5,000 free PTE’s with a Warning if there is less than 10,000 free PTE’s. Lack of enough PTEs can result in system wide hangs</td></tr>
<tr><td nowrap>\Memory\Pages Input/sec > 1000</td>	<td>15 Mins</td>	<td>Pages Input/sec is the rate at which pages are read from disk to resolve hard page faults</td></tr>
<tr><td nowrap>\Memory\Pages/sec > 0.4</td>	<td>15 Mins</td>	<td>If it is high, then the system is likely running out of memory by trying to page the memory to the disk. Pages/sec is the rate at which pages are read from or written to disk to resolve hard page faults</td></tr>
<tr><td nowrap>\Memory\Pool Paged Bytes > 0.5</td>	<td>15 Mins</td>	<td>if the system is becoming close to the maximum Pool paged memory size. Pool Paged Bytes is the size, in bytes, of the paged pool, an area of system memory (physical memory used by the operating system</td></tr>
<tr><td nowrap>\PhysicalDisk(*)\Avg. Disk sec/Read > 15ms</td>	<td>15 Mins</td>	<td>Avg. Disk sec/Read is the average time, in seconds, of a read of data to the disk</td></tr>
<tr><td nowrap>\PhysicalDisk(*)\Avg. Disk sec/Write  3000</td>	<td>15 Mins</td>	<td>Avg. Disk sec/Write is the average time, in seconds, of a write of data to the disk</td></tr>
<tr><td nowrap>\Process(*)\Handle Count > 1000</td>	<td>15 Mins</td>	<td>How many handles each process has open and determines if a handle leaks is suspected. A process with a large number of handles and/or an aggresive upward trend could indicate a handle leak which typically results in a memory leak. </td></tr>
<tr><td nowrap>\Process(*)\IO Data Operations/sec > 1000</td>	<td>15 Mins</td>	<td>The rate at which the process is issuing read and write I/O operations. This counter counts all I/O activity generated by the process to include file, network and device I/Os</td></tr>
<tr><td nowrap>\Process(*)\IO Other Operations/sec > 500mb</td>	<td>15 Mins</td>	<td>This counter counts all I/O activity generated by the process to include file, network and device I/Os</td></tr>
<tr><td nowrap>\Process(*)\Private Bytes > 500mb</td>	<td>15 Mins</td>	<td>Private Bytes is the current size, in bytes, of memory that this process has allocated that cannot be shared with other processes</td></tr>
<tr><td nowrap>\Process(*)\Working Set > 6600 </td>	<td>15 Mins</td>	<td>Working Set is the current size, in bytes, of the Working Set of this process. The Working Set is the set of memory pages touched recently by the threads in the process. If free memory in the computer is above a threshold, pages are left in the Working Set of a process even if they are not in use.</td></tr>
<tr><td nowrap>\Process(*)Thread Count > 0.5</td>	<td>15 Mins</td>	<td>For 2GB memory maximum 6600 threads. The number of threads currently active in this process. An instruction is the basic unit of execution in a processor, and a thread is the object that executes instructions. Every running process has at least one thread.</td></tr>
<tr><td nowrap>\Processor(*)\% Interrupt Time > 0.7</td>	<td>15 Mins</td>	<td>This counter indicates the percentage of time the processor spends receiving and servicing hardware interrupts. This value is an indirect indicator of the activity of devices that generate interrupts, such as network adapters. A dramatic increase in this counter indicates potential hardware problems</td></tr>
<tr><td nowrap>\Processor\% Privileged Time > 90</td>	<td>15 Mins</td>	<td>Consistently over 75 percent indicates a bottleneck.</td></tr>
<tr><td nowrap>Memory\% Committed Bytes in Use > 0.9</td>	<td>5mins</td>	<td>This counter displays the current percentage value only. % Committed Bytes In Use is the ratio of Memory\Committed Bytes to the Memory\Commit Limit</td></tr>
<tr><td nowrap>Processor\% Processor Time >= </td>	<td>15 Mins</td>	<td>This counter is the primary indicator of processor activity. High values many not necessarily be bad. However, if the other processor-related counters are increasing linearly such as % Privileged Time or Processor Queue Length, high CPU utilization may be worth investigating</td></tr>
<tr><td nowrap>System\Processor Queue Length  </td>	<td>15 Mins</td>	<td>The processor queue is the collection of threads that are ready but not able to be executed by the processor because another active thread is currently executing.</td></tr>

</table>    


Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
